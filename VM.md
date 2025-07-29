---
- name: Создание Windows VM на Proxmox px02
  hosts: localhost
  gather_facts: false
  vars:
    proxmox_host: "px02"
    proxmox_user: "root@pam"
    proxmox_password: "Pharmacia_"
    proxmox_node: "px02"
    vmid: 120
    vm_name: "win-vm"
    iso_storage: "local"
    iso_image: "Windows.iso"
    disk_size_gb: 50
    memory_mb: 4096
    cores: 4
  tasks:
    - name: Создать виртуальную машину Windows
      community.general.proxmox_kvm:
        api_host: "{{ proxmox_host }}"
        api_user: "{{ proxmox_user }}"
        api_password: "{{ proxmox_password }}"
        node: "{{ proxmox_node }}"
        vmid: "{{ vmid }}"
        name: "{{ vm_name }}"
        cores: "{{ cores }}"
        memory: "{{ memory_mb }}"
        sockets: 1
        scsihw: virtio-scsi-pci
        boot: cd
        bootdisk: scsi0
        ide2: "{{ iso_storage }}:iso/{{ iso_image }},media=cdrom"
        disk:
          - size: "{{ disk_size_gb }}G"
            type: scsi
            storage: "{{ iso_storage }}"
        net:
          - model: virtio
            bridge: vmbr0
        ostype: win10
        agent: 1
        state: present
