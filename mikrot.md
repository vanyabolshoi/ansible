- hosts: localhost
  gather_facts: false
  tasks:
    - name: Get ansible version using python import
      ansible.builtin.debug:
        msg: "{{ ansible_version }}"
      vars:
        ansible_version: "{{ ansible_version_full.stdout_lines[0] }}"
      run_once: true
      delegate_to: localhost

    - name: Run ansible --version command
      command: ansible --version
      register: ansible_version_full
      changed_when: false
