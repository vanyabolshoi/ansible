- name: Открыть порт 8080 на MikroTik
  hosts: mikrotik
  gather_facts: no
  collections:
    - community.routeros
  tasks:
    - name: Добавить правило firewall для порта 8080 TCP
      routeros_firewall_filter:
        chain: input
        protocol: tcp
        dst_port: 8080
        action: accept
        state: present
