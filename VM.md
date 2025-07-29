- hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину Windows в Proxmox
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "roo- hosts: localhost
  gather_facts: false
  vars:
    vm_baseid: 127
    vm_count: 4

  tasks:
    - name: Создать 4 Windows ВМ без автозапуска
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px02"
        vmid: "{{ vm_baseid + item }}"
        name: "win-vm-{{ item }}"
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
      loop: "{{ range(0, vm_count) | list }}"
t@pam"
        api_password: "Pharmacia_"
        validate_certs: false
        node: "px02"
        vmid: 127
        name: "win-vm"
        memory: 4096
        cores: 4
        sockets: 1
        scsihw: virtio-scsi-pci
        boot: cd
        bootdisk: scsi0
        ide2: "local:iso/Windows.iso,media=cdrom"
        scsi0: "local-lvm:50,format=raw"
        net0: "virtio,bridge=vmbr0"
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
        vmid: 127
        state: started
