- name: Открыть порт 8080 на MikroTik
  hosts: mikrotik
  collections:
    - community.routeros
  gather_facts: no
  tasks:
    - name: Добавить правило firewall для порта 8080 TCP
      routeros_firewall_filter:
        chain: input
        protocol: tcp
        dst_port: 8080
        action: accept
        state: present
