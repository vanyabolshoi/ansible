- name: Check ansible version
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Run ansible --version
      command: ansible --version
      register: ansible_version

    - name: Show ansible version output
      debug:
        var: ansible_version.stdout_lines
