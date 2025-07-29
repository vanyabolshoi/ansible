- name: Создать Windows KVM ВМ в Proxmox
  hosts: proxmox
  gather_facts: false
  tasks:
    - name: Создать Windows ВМ
      community.general.proxmox_kvm:
        api_host: "{{ proxmox_api_host }}"
        api_token_id: "{{ proxmox_api_token_id }}"
        api_token_secret: "{{ proxmox_api_token_secret }}"
        validate_certs: "{{ validate_certs | default(false) }}"
        node: "px02"
        vmid: 200
        name: win-vm-200
        memory: 8192
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        ostype: win10
        ide:
          0: "local-lvm:vm-200-disk-0,size=50G"
          2: "local:iso/Windows.iso,media=cdrom"
        net:
          0: "model=e1000,bridge=vmbr0"
        boot: cd
        bootdisk: ide0
        agent: 1
        onboot: false
        state: present
