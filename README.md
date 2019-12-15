# Zookeeper cluster with Terraform and Ansible

This code will prepare and configure the Operating System, install prerequisites, download and install Apache Zookeeper - forming an ensemble from all nodes, it will download and install Apache Zookeeper - forming a cluster from all nodes.

The code has two layers, first being infrastructure layer if the goal is to deploy the environment to AWS. It is managed by Terraform. Second layer is responsible for OS configuration and applications deployment and configuration. It is managed by Ansible. Thanks to that, you can deploy it to on prem machines (either physical or virtual) using Anisble only. At the bottom of this README there is instruction how to run the deployment without Terraform part.

As part of the deployment, several non default settings are applied for OS and Zookeeper. If you need to change the values, you can find them in following files:

### Zookeeper

File: `playbooks/inventories/dev/group_vars/zk_servers/vars`

Default values:

```
############################################################################
# Settings for 'pythian.zookeeper' role
############################################################################

#zk_version: "3.4.12"
#zk_version: "3.4.6"
zk_user: "zookeeper"
zk_group: "zookeeper"
zk_home_dir: "/home/zookeeper"
zk_download_path: "/tmp"
zk_checksum: "c686f9319050565b58e642149cb9e4c9cc8c7207aacc2cb70c5c0672849594b9"
zk_install_dir: "/opt/zookeeper"
zk_conf_dir: "{{ zk_install_dir }}/conf"
zk_data_dir: "/data/zookeeper"
zk_log_dir: "{{ zk_data_dir }}/logs"
zk_port: 2181
#zk_max_client_connections: 100
zk_max_client_connections: 300
zk_tick_time: 2000
zk_init_ticks_limit: 10
zk_sync_limit: 5
zk_remove_download: false
zk_leader_port: 2888
zk_leader_election_port: 3888
zk_working_dir: "{{ zk_install_dir }}/current"
zk_logging_dir: "/var/log/zookeeper"
```

## Terraform Managed Deployment to AWS

### Configure users and their public keys

Edit the `files/users/zookeeper-dev.yml` file. There is an example in the file, use it to adjust it to your needs.

### Install Terraform (Ubuntu, for example):

From this project directory, execute the follwing script to install terraform at the version specified in the `tfconfig.tf` file:
```bash
~$ ./scripts/tf_install.sh
```

Or execute the following installation commands:

```bash
export TERRAFORM_VERSION="<< DESIRED_TERRAFORM_VERSION_HERE >>"
export TERRAFORM_INSTALL_DIR="/usr/local/bin"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O /tmp/terraform.zip
sudo mkdir -p $TERRAFORM_INSTALL_DIR
sudo rm -f /usr/local/bin/terraform
sudo unzip /tmp/terraform.zip -d $TERRAFORM_INSTALL_DIR
sudo chmod +x $TERRAFORM_INSTALL_DIR/terraform
rm /tmp/terraform.zip
```

### Set up your AWS access credentials, following instructions here:

https://www.terraform.io/docs/providers/aws/

You may want to create dedicated user for terraform, make sure it has Programmatic access and the easiest way to provide proper access is to add *AdministratorAccess* policy to it. Then get the Access key ID and Secret Access key which will be needed to get everything working. In the link above you will find couple of ways how to setup authentication. One of them is to add everything to `terraform.tfvars` file in root folder of the repository.

### Terraform variables setup

Here's example of how that file should look like:

```
AWS_ACCESS_KEY="<your_access_key>"
AWS_SECRET_KEY="<your_secret>"

PATH_TO_PRIVATE_KEY = "/home/mpastecki/.ssh/mpastecki_id_rsa"

PRIVATE_KEY_FILE_NAME = "mpastecki_id_rsa"

PATH_TO_PUBLIC_KEY = "/home/mpastecki/.ssh/mpastecki_id_rsa.pub"

ansible_inventory_users_vars_file_path = "./files/users/zookeeper-dev.yml"

#ansible_options     = "-v --tags=pythian.zookeeper"
ansible_options     = "-v"

suppress_zookeeper_handlers = "true"
```

All ansible roles use tags and thus you can use `--tags` option to limit which role/roles you want to execute. You can use `--skip-tags` to exclude roles from execution.

*IMPORTANT*
If you don't want to run handlers that will start or restart the zookeeper service if anything has been changed in their configs, you may want to set `suppress_zookeeper_handlers` variable to true as in the example above. You will have to perform the restart manually then to apply the changes.

### Run the ssh-agent:
```bash
~$ eval $(ssh-agent)
~$ ssh--add /path/to/your/private/key/file
```

### Initialize Terraform

Run the `terraform init` command

### Run Terraform:

```bash
~$ terraform plan
...
~$ terraform apply
...
```

## Ansible Only Deployment to On Prem

This guide will use an example of deploying the cluster to three nodes. You need to manually configure some things which normally would be done by Terraform.

Let's say you want to deploy two nodes Zookeeper cluster to following machines:

* pythian-zookeeper1.uat
* pythian-zookeeper2.uat
* pythian-zookeeper3.uat

Clone the repository to first of them.

```bash
mpastecki@pythian-zookeeper1:/opt/pythian$ pwd
/opt/pythian
mpastecki@pythian-zookeeper1:/opt/pythian$ git clone <repo_address>
mpastecki@pythian-zookeeper1:/opt/pythian$ cd aws_tf_ansible_zookeeper_cluster/
```

### Edit the `playbooks/.ssh/config.ansiblespec` file. Make sure this is its content:

```
###############################################
# SSH config file used for Ansible_spec tests #
###############################################
# NOTE: The contents of this file are managed by terraform

# Connect to remote hosts via SSH using '${ssh_user}' user
Host *
    ForwardAgent no
    ForwardX11 no
    ForwardX11Trusted yes
    User mpastecki
    Port 22
    Protocol 2
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30
    IdentityFile /home/nonexistent_user_for_ansiblespec/.ssh/ceZmGbfBIgflJHmIgvVvbdQdTOzXIySH.pem
```

### Edit the `playbooks/inventories/dev/group_vars/all/vars` file.

Add following section:

```
# Global settings - common variables used across multiple roles
############################################################################

admin_user: "mpastecki"
vmlc_stage: "VMLC.all"
```

Make sure, the admin_user is a user with full sudo rights. This is the user that should execute Ansible playbooks.

Also add selinux section to the file:

```
############################################################################
# Settings for 'pythian.selinux' role
############################################################################

selinux_conf_file: /etc/selinux/config
selinux_state: disabled
selinux_policy: default
selinux_localdefs: 0
```

### Edit the `playbooks/inventories/dev/group_vars/all/vars_users_tf_managed` file.

Here is an example of how it should look like:

```
---
# file: vars
# Non-sensitive group variables and references to sensitive variables.

############################################################################
# Settings for 'pythian.instance_os_user_mgmt' role
############################################################################

# Users are the normal non-sudoers users, admins have sudo access, and
# delete_users are accounts that needs to be deleted.

users:
  - name: balatero
    key: "<pub_key>"

admins:
  - name: pastecki
    key: "<pub_key>"
  - name: parducci
    key: "<pub_key>"

groupname:
  - sudo
  - dev
  - admin

user_group:
  - groupname: sudo
    group_users:
      - pastecki
      - parducci
      - balatero
  - groupname: admin
    group_users:
      - pastecki
      - parducci
      - balatero
  - groupname: dev
    group_users:
      - pastecki
      - parducci
      - balatero
```

### Edit the `playbooks/inventories/dev/group_vars/zk_servers/vars_tf_managed` file.

It should contain one variable `zk_servers`, its value is a list of all zookeeper servers.

```
---
# file: vars_tf_managed
# Non-sensitive group variables and references to sensitive variables.
# NOTE: The contents of this file are managed by terraform

############################################################################
# Settings for 'pythian.zookeeper' role
############################################################################

zk_servers:
  - pythian-zookeeper1.uat
  - pythian-zookeeper2.uat
  - pythian-zookeeper3.uat

```

### Edit the `playbooks/inventories/dev/hosts` file

bastion_servers should be set to localhost.

The myid must have value between 1 and 255, so start with 1 and also increment by 1. The variable with proper id are defined in Ansible hosts file.

```
# Ansible inventory file

#------------------------
# Child groups
#------------------------

[bastion_servers]
localhost

[zk_servers]
pythian-zookeeper1.uat zk_myid=1
pythian-zookeeper2.uat zk_myid=2
pythian-zookeeper3.uat zk_myid=3
```

### Execute the Ansible playbook

Finally from playbooks directory, run the playbook to setup the environment

```bash
ansible-playbook site.yml --limit "all" --inventory-file=inventories/dev/hosts --become --user=mpastecki --verbose --extra-vars 'admin_user=mpastecki' --extra-vars 'ansible_python_interpreter=/usr/bin/python3' --extra-vars 'ansible_inventory_name=dev' --ask-pass --ask-become-pass
```

Once the Ansible playbook is executed, run server spec tests to validate the environment:

```bash
sudo chmod +x ./scripts/testing/infrastructure/ansiblespec/rake_exec_ansiblespec_tasks.sh
./scripts/testing/infrastructure/ansiblespec/rake_exec_ansiblespec_tasks.sh \
--playbook tests/ansible_spec_tests__all.yml \
--inventory inventories/dev/hosts \
--vars-dirs-path inventories/dev \
--ssh-config-file .ssh/config.ansiblespec
```
