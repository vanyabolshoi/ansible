---
- name: Создание ВМ на Proxmox
  hosts: localhost
  gather_facts: no
  vars:
    vm_id: 108
    vm_name: test-vm
    cores: 2
    memory: 2048
    disk_size: 8G
    iso_file: "local:iso/debian-12.7.0-amd64-netinst.iso"
    storage: "local-lvm"

  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_user: "{{ proxmox_user }}"
        api_password: "{{ proxmox_password }}"
        api_host: "{{ proxmox_host }}"
        node: "{{ proxmox_node }}"
        vmid: "{{ vm_id }}"
        name: "{{ vm_name }}"
        cores: "{{ cores }}"
        memory: "{{ memory }}"
        scsihw: virtio-scsi-pci
        ide2: "{{ iso_file }},media=cdrom"
        sata0: "{{ storage }}:{{ disk_size }}"
        ostype: l26
        net0: virtio,bridge=vmbr0
        boot: cdn
        state: present
