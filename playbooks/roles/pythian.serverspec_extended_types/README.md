pythian.serverspec_extended_types
=========

An Ansible role that installs the Serverspec extended types for Serverspec 2.x.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    serverspec_extended_types_version: "0.1.1"

The version of the serverspec_extended_types gem to install.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.serverspec_extended_types }

License
-------

MIT / BSD

Author Information
------------------

Rory Bramwell   
DevOps Engineer, Pythian  
Email: [bramwell@pythian.com](mailto:bramwell@pythian.com)
