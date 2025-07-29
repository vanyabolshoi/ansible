- name: Создать виртуальную машину Windows в Proxmox
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину Windows
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px03"
        vmid: 127
        name: "win-vm"
        memory: 8192
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        ostype: win10
        ide:
          0: "VMstorage02:vm-127-disk-0,size=50G"
          1: "local:iso/virtio-win.iso,media=cdrom"
          2: "local:iso/Win10_22H2.iso,media=cdrom"
        net:
          0: "model=virtio,bridge=vmbr0"
        boot: cd
        bootdisk: ide0
        agent: 1
        onboot: true
        state: present
