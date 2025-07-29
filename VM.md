- name: Создание Windows ВМ с автоматическим VMID
  hosts: localhost
  gather_facts: false
  tasks:

    - name: Получить список всех VM
      uri:
        url: "https://{{ proxmox_api_host }}/api2/json/cluster/resources?type=vm"
        method: GET
        user: "{{ proxmox_api_token_id }}"
        password: "{{ proxmox_api_token_secret }}"
        force_basic_auth: true
        validate_certs: false
      register: vm_list

    - name: Найти первый свободный VMID начиная с 100
      set_fact:
        used_ids: "{{ vm_list.json.data | map(attribute='vmid') | list }}"
        next_id: "{{ query('sequence', 'start=100 end=999') | difference(used_ids | map('int') | list) | first }}"

    - name: Создать виртуальную машину Windows
      community.general.proxmox_kvm:
        api_host: "{{ proxmox_api_host }}"
        api_user: "{{ proxmox_api_token_id }}"
        api_token_secret: "{{ proxmox_api_token_secret }}"
        validate_certs: false
        node: "px03"
        vmid: "{{ next_id }}"
        name: "win-vm-{{ next_id }}"
        memory: 8192
        cores: 4
        sockets: 1
        ostype: win10
        ide:
          0: "VMstorage02:vm-{{ next_id }}-disk-0,size=50G"
          2: "local:iso/Windows.iso,media=cdrom"
        net:
          0: "model=e1000,bridge=vmbr0,firewall=1"
        boot: cd
        bootdisk: ide0
        agent: 1
        onboot: true
        state: started
