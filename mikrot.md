---
- name: Настройка MikroTik
  hosts: mikrotik
  gather_facts: false

  tasks:
    - name: Добавить правило firewall для порта 8080 (TCP)
      community.routeros.routeros_firewall_filter:
        chain: input
        action: accept
        protocol: tcp
        dst_port: 8080
        comment: "Разрешить 8080"
