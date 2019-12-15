pythian.rsyslog
=========

An Ansible role that installs Rsyslog.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    rsyslog_version: "8.32.0"

rsyslog version to install from repository

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.rsyslog }

License
-------

MIT / BSD

Author Information
------------------

Pythian
