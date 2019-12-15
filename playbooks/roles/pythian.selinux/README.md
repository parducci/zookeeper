pythian.selinux
=========

An Ansible role that Installs and configures SELinux.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    selinux_conf_file: /etc/selinux/config

The location of the SELinux config file.

    selinux_state: enforcing

The SELinux policy to apply. Valid values: "enforcing", "permissive" and "disabled".
- enforcing - SELinux security policy is enforced.
- permissive - SELinux prints warnings instead of enforcing.
- disabled - No SELinux policy is loaded.

    selinux_policy: default

The SELinux policy to use. Valid values: "targeted", "strict", "default", "mls" and "src".
- default - equivalent to the old strict and targeted policies
- mls - Multi-Level Security (for military and educational use)
- src - Custom policy built from source

    selinux_localdefs: 0

Check local definition changes. For the majority of cases, this should always be set to 0.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.selinux }

License
-------

MIT / BSD

Author Information
------------------

Pythian
