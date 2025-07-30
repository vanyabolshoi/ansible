- name: Открыть порт 8080 на MikroTik
  hosts: mikrotik
  gather_facts: no
  collections:
    - community.routeros

  tasks:
    - name: Добавить правило firewall для порта 8080 (TCP)
      routeros_firewall_filter:
        host: "{{ inventory_hostname }}"
        user: "{{ mikrotik_user }}"
        password: "{{ mikrotik_password }}"
        chain: input
        protocol: tcp
        dst_port: 8080
        action: accept
        comment: "Open port 8080"
        state: present
