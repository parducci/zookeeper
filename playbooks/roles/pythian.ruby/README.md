pythian.ruby
=========

An Ansible role that installs the Ruby.

Requirements
------------

- Ansible verison 2.2.1.0+

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

    ruby_packages:
      - gcc
      - make
      - ruby
      - ruby-dev
      - rubygems-integration
      - rake

The ruby packages to install.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: pythian.ruby }

License
-------

MIT / BSD

Author Information
------------------

Rory Bramwell   
DevOps Engineer, Pythian  
Email: [bramwell@pythian.com](mailto:bramwell@pythian.com)
