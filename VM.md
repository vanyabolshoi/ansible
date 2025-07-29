- hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину Windows в Proxmox (без автозапуска)
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px02"
        vmid: 127
        name: "win-vm"
        memory: 4096
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        ostype: win10
        ide2: "local:iso/Windows.iso,media=cdrom"
        scsi0: "local-lvm:50,format=raw"
        net0: "virtio,bridge=vmbr0"
        boot: cd
        bootdisk: scsi0
        agent: 1
        onboot: false
        state: present
