- hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину Windows в Proxmox
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px02"
        vmid: 124
        name: "win-vm"
        memory: 4096
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        boot: cd
        bootdisk: scsi0
        ide:
          2: "local:iso/Windows.iso,media=cdrom"
        scsi:
          0: "local-lvm:50,format=raw"
        net:
          0: "model=virtio,bridge=vmbr0"
        ostype: win10
        agent: 1
        state: present

    - name: Запустить виртуальную машину Windows
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px02"
        vmid: 120
        state: started
