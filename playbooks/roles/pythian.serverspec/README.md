pythian.serverspec
=========

An Ansible role that installs the Serverspec.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    serverspec_version: "2.41.3"

The version of the serverspec gem to install.

Dependencies
------------

pythian.ruby - Installs Ruby.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.serverspec }

License
-------

MIT / BSD

Author Information
------------------

Rory Bramwell   
DevOps Engineer, Pythian  
Email: [bramwell@pythian.com](mailto:bramwell@pythian.com)
