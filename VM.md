---
- name: Создание ВМ на Proxmox
  hosts: localhost
  gather_facts: no
  vars:
    proxmox_host: "172.16.10.5"
    proxmox_user: "root@pam"
    proxmox_password: "Pharacia_"
    proxmox_node: "px02"

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
        disk_size: 10G
        net0: virtio,bridge=vmbr0
        state: present
