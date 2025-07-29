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
        vmid: 127
        name: "win-vm"
        memory: 8192
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        ostype: win10
        ide:
          0: "VMstorage02:vm-127-disk-0,size=50G"
          2: "local:iso/Windows.iso,media=cdrom"
        net:
          0: "model=e1000,bridge=vmbr0,firewall=1,hwaddr=CA:BE:9B:08:D3:BD"
        usb:
          0: "host=04b3:4010"
        boot: cd
        bootdisk: ide0
        agent: 1
        onboot: false
        state: present
