- name: Check ansible version
  hosts: localhost
  gather_facts: false
  tasks:
    - command: ansible --version
      register: ansible_version
    - debug:
        var: ansible_version.stdout_lines
