- hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "ansible@pve"
        api_password: "Pharacia_"
        validate_certs: false
        node: "px02"
        vmid: 201
        name: "vm-example"
        memory: 2048
        cores: 2
        scsi:
          - storage=local-lvm,size=32G
        cdrom: "local:iso/debian-12.iso"
        net:
          - model=virtio,bridge=vmbr0
        ostype: l26
        boot: "cdn"
        bootdisk: "scsi0"
        state: present
