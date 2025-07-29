- name: Создать Windows ВМ с автоматическим VMID из инвентаря (используем токен)
  hosts: proxmox
  gather_facts: false
  vars:
    vm_name: win-vm
    start_vmid: 100
  tasks:
    - name: Получить список всех VM
      uri:
        url: "https://{{ proxmox_api_host }}:8006/api2/json/cluster/resources?type=vm"
        method: GET
        headers:
          Authorization: "PVEAPIToken={{ proxmox_api_token_id }}={{ proxmox_api_token_secret }}"
        validate_certs: "{{ validate_certs | default(false) }}"
      register: vm_list

    - name: Сформировать список занятых vmid
      set_fact:
        used_vmids: "{{ vm_list.json.data | map(attribute='vmid') | list }}"

    - name: Найти свободный vmid
      set_fact:
        free_vmid: "{{ item }}"
      loop: "{{ range(start_vmid, 9999) | list }}"
      when: item not in used_vmids
      register: vmid_search
      until: free_vmid is defined
      retries: 1000
      delay: 0

    - name: Создать Windows ВМ с найденным vmid
      community.general.proxmox_kvm:
        api_host: "{{ proxmox_api_host }}"
        api_token_id: "{{ proxmox_api_token_id }}"
        api_token_secret: "{{ proxmox_api_token_secret }}"
        validate_certs: "{{ validate_certs | default(false) }}"
        node: "px02"
        vmid: "{{ free_vmid }}"
        name: "{{ vm_name }}"
        memory: 8192
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        ostype: win10
        ide:
          0: "local-lvm:vm-{{ free_vmid }}-disk-0,size=50G"
          2: "local:iso/Windows.iso,media=cdrom"
        net:
          0: "model=e1000,bridge=vmbr0"
        boot: cd
        bootdisk: ide0
        agent: 1
        onboot: false
        state: present
