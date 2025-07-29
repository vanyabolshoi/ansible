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
        cores: 2
        memory: 2048
        net0: "virtio,bridge=vmbr0"
        ide2: "local:iso/debian-12.iso,media=cdrom"
        sata0: "local-lvm:32"
        ostype: l26
        boot: "cdn"
        bootdisk: "sata0"
        state: present
