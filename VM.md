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
        net:
          net0:
            model: "{{ net_model }}"
            bridge: "{{ net_bridge }}"
        ostype: l26
        state: present
