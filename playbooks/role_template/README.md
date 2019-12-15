Ansible role template
====

## Overview

The `pythian.rolename` template adheres to the check-install-config-service (CICS) Ansible role pattern. The template is also outfitted with tags for Virtual Machine Lifecycle (VMLC) stages, and includes a `spec/` directory with `_spec.rb` files for Ansible_spec tests. The spec test files are also outfitted with VMLC tags.

## Role directory layout

```bash
pythian.rolename/
├── defaults
│   └── main.yml
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── spec
│   ├── rolename_spec.rb
│   └── spec_helper.rb
├── tasks
│   ├── check_vars.yml
│   ├── cleanup.yml
│   ├── config.yml
│   ├── install.yml
│   ├── main.yml
│   └── service.yml
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

## check-install-config-service (CICS) Ansible role pattern

The check-install-config-service (CICS) Ansible role pattern organizes a role into common application setup steps. The pattern consists of a `tasks/main.yml` file that's organized with includes for checking required variables, installing application components, configuring application settings, and managing the application's services.

Example of check-install-config-service (CICS) Ansible role pattern applied to `tasks/main.yml` file:

```yaml
---
# tasks file for pythian.rolename

- import_tasks: check_vars.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:check"
    - "pythian.check"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"

- import_tasks: install.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:install"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"

- import_tasks: config.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:config"
    ###########################
    - "VMLC.provision"

- import_tasks: service.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:service"
    ###########################
    - "VMLC.provision"

- import_tasks: cleanup.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:cleanup"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"
```

Here the `check_vars.yml` and `install.yml` are allowed to run when either `VMLC.provision` or `VMLC.image_build` tags are targeted, but `config.yml` and `service.yml ` are only allowed to run when the `VMLC.provision` tag is targeted.


## Virtual Machine Lifecycle stages

The concept of virtual machine lifecycle (VMLC) stages was introduced to identify, by way of tagging, the components of Ansible roles and Ansible_spec tests that are related to image builds, provisioning or all activities. This enables targeting of specific parts of the provisioning and testing activities for image builds or provisioning if needed. For the purposes of creating Google Cloud Platform VM images, the image build VMLC stage is targeted.

Valid VMLC stages include the following:

- `VMLC.all`
- `VMLC.provision`
- `VMLC.image_build`

VMLC tags have been applied to all Ansible roles and Ansible_spec tests in the Data Hub (`tf_gcp_dep_data_hub`) and Encryption Service (`tf_gcp_dep_encr_svc`) GitHub repositories.

### VMLC stage tagging in Ansible roles

Assuming a role adheres to the CICS Ansible role pattern, the role's `tasks/main.yml` file should be further outfitted with VMLC stage tags indicating the VMLC stage(s) the role is suggested to run in. Multiple VMLC tags may be applied to a given section.

Example of VMLC tagging in the `pythian.rolename` Ansible role's `tasks/main.yml` file:

```yaml
---
# tasks file for pythian.rolename

- import_tasks: check_vars.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:check"
    - "pythian.check"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"

- import_tasks: install.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:install"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"

- import_tasks: config.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:config"
    ###########################
    - "VMLC.provision"

- import_tasks: service.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:service"
    ###########################
    - "VMLC.provision"

- import_tasks: cleanup.yml
  tags:
    - "pythian.rolename"
    - "pythian.rolename:cleanup"
    ###########################
    - "VMLC.provision"
    - "VMLC.image_build"
```

Here the `check_vars.yml` and `install.yml` are allowed to run when either `VMLC.provision` or `VMLC.image_build` tags are targeted, but `config.yml` and `service.yml ` are only allowed to run when the `VMLC.provision` tag is targeted.

Using the above example, execution result if `--tags VMLC.provision` is passed to Ansible on the command-line:

- import_tasks: check_vars.yml
- import_tasks: install.yml
- import_tasks: config.yml
- import_tasks: service.yml
- import_tasks: cleanup.yml

Using the above example, execution result if `--tags VMLC.image_build` is passed to Ansible on the command-line:

- import_tasks: check_vars.yml
- import_tasks: install.yml
- import_tasks: cleanup.yml

### VMLC stage conditionals in Ansible_spec tests

Ansible_spec tests should be grouped in accordance with the CICS Ansible role pattern. Assuming a role adheres to the CICS Ansible role pattern, the role's `spec/*_spec.rb ` file should be outfitted with VMLC stage conditionals indicating the VMLC stage(s) the test(s) is suggested to run in. Multiple VMLC stage values may be specified for a given section.

Example of VMLC tagging in the `pythian.rolename` Ansible role's `spec/rolename_spec.rb` file:

```ruby
require 'spec_helper'

describe 'Running serverspec tests for pythian.rolename role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename is installed' do

      describe package('apache2') do
        it { should be_installed }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename is configured' do

      describe file('/etc/httpd/conf/httpd.conf') do
        its(:content) { should match /ServerName www.xyz.com/ }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rolename service is running' do

      describe service('apache2') do
        it { should be_running }
      end

      describe port(80) do
        it { should be_listening }
      end

    end

  end

end
```

Here tests for the config section are only run when the `vmlc_stage` Ansible variable is set to `VMLC.all` or `VMLC.provision`.
