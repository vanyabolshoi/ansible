---
- name: Создание ВМ на Proxmox
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_user: "{{ proxmox_user }}"
        api_password: "{{ proxmox_password }}"
        api_host: "{{ proxmox_host }}"
        node: "{{ proxmox_node }}"
        vmid: 110
        name: "vm-test"
        cores: 2
        memory: 2048
        disks:
          - size: 10G
            storage: local-lvm
            type: scsi
        net:
          - model: virtio
            bridge: vmbr0
        ostype: l26
        state: present
