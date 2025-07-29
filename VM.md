- name: Создание ВМ на Proxmox
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_user: "{{ proxmox_user }}"
        api_password: "{{ proxmox_password }}"
        api_host: "{{ proxmox_host }}"
        node: "{{ proxmox_node }}"
        vmid: "{{ vm_id }}"
        name: "{{ vm_name }}"
        memory: "{{ vm_memory }}"
        cores: "{{ vm_cores }}"
        sockets: 1
        net:
          net0: "virtio,bridge=vmbr0"
        ostype: l26
        ide2: "local:cloudinit"
        scsihw: virtio-scsi-pci
        scsi0: "{{ vm_disk_storage }}:{{ vm_disk_size }}"
        ciuser: "{{ vm_user }}"
        cipassword: "{{ vm_password }}"
        ipconfig0: "ip={{ vm_ip }}/24,gw={{ vm_gateway }}"
        pool: "vms"
        state: present
