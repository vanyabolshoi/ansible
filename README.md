---
- name: Создать виртуальную машину (KVM) в Proxmox
  hosts: localhost
  gather_facts: false
  vars:
    vmid: 200
    name: "test-vm"
    cores: 2
    sockets: 1
    memory: 2048           # в МБ (2 ГБ)
    disk_gb: 32            # в ГБ
    iso_storage: "local"
    iso_image: "iso/ubuntu-22.04-live-server-amd64.iso"
    storage: "local-lvm"
    net_bridge: "vmbr0"
    vlan_tag: ""
    net_model: "virtio"
    network_mac: ""
    boot_order: "cd"

  tasks:
    - name: Создать виртуальную машину
      community.general.proxmox_kvm:
        api_host: "172.16.10.5"
        api_user: "root@pam"
        api_password: "{{ lookup('env', 'PVE_PASS') }}"
        vmid: "{{ vmid }}"
        name: "{{ name }}"
        cores: "{{ cores }}"
        sockets: "{{ sockets }}"
        memory: "{{ memory }}"
        scsihw: "virtio-scsi-pci"
        boot: "{{ boot_order }}"
        ide2: "{{ iso_storage }}:{{ iso_image }},media=cdrom"
        sata0: "{{ storage }}:{{ disk_gb }}"
        net0: "{{ net_model }},bridge={{ net_bridge }}{% if vlan_tag %},tag={{ vlan_tag }}{% endif %}{% if network_mac %},macaddr={{ network_mac }}{% endif %}"
        ostype: l26
        agent: 1
        ciuser: "ubuntu"
        cipassword: "ubuntu"
        searchdomain: "local"
        nameserver: "8.8.8.8"
        state: pres
