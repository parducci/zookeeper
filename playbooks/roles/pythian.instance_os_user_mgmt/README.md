pythian.instance_os_user_mgmt
=========

An Ansible role that manages Google Compute Engine (GCE) VM instance operating system users.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    admin_user: ""

Admin or deployment user whose home directory files will be deployed to.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.instance_os_user_mgmt }

License
-------

MIT / BSD

Author Information
------------------

Pythian
