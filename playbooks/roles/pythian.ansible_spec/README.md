pythian.ansible_spec
=========

An Ansible role that installs the Ansible_spec.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    ansible_spec_version: 0.2.22

The version of the ansible_spec gem to install.

Dependencies
------------

pythian.ruby - Installs Ruby.

Example Playbook
----------------

    - hosts: ansibleservers
      roles:
         - { role: pythian.ansible_spec }

License
-------

MIT / BSD

Author Information
------------------

Rory Bramwell   
DevOps Engineer, Pythian  
Email: [bramwell@pythian.com](mailto:bramwell@pythian.com)
