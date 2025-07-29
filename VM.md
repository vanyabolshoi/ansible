---
- name: Создание ВМ на Proxmox
  hosts: localhost
  gather_facts: no
  vars_files:
    - vars.yml

  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_user: "{{ proxmox_user }}"
        api_password: "{{ proxmox_password }}"
        api_host: "{{ proxmox_host }}"
        node: "{{ proxmox_node }}"
        vmid: 108
        name: "test-vm"
        cores: 2
        memory: 2048
        disk_size: 8G
        scsihw: virtio-scsi-pci
        ide2: "local:iso/debian-12.7.0-amd64-netinst.iso,media=cdrom"
        sata0: "local-lvm:8"
        ostype: l26
        net0: virtio,bridge=vmbr0
        boot: cdn
        state: present
