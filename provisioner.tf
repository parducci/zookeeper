# Data templates for use by the provisioner
data "template_file" "ansible_hosts" {
  template = "${file("templates/ansiblehosts.tpl")}"

  vars {
    bastion       = "localhost"   #never move, update or variable-ize this; it's only for the ansible workstation inventory
    zk-node       = "${data.template_file.zookeeper_cfg_file_myids_entry_dict_list.rendered}"
  }
}

data "template_file" "ansible_inventory_all_vars_tf_managed" {
  template = "${file("templates/ansible_inventory_all_vars_tf_managed.tpl")}"

  vars {
    admin_user = "${var.admin_user}"
    vmlc_stage = "${var.vmlc_stage}"
  }
}

data "template_file" "zookeeper_cfg_file_myids_entry_dict" {
  template = "${element(module.zookeeper.zookeeper_private_dns, count.index)} zk_myid=${count.index + 1}"
  count = "${module.zookeeper.zookeeper_nodes_count}"
}

data "template_file" "zookeeper_cfg_file_myids_entry_dict_list" {
  template = "$${list_of_dicts}"

  vars {
    list_of_dicts = "${join("\n", data.template_file.zookeeper_cfg_file_myids_entry_dict.*.rendered)}"
  }
}

data "template_file" "zookeeper_cfg_file_ids_entry_dict" {
  template = "${element(module.zookeeper.zookeeper_private_dns, count.index)} , count.index)}"
  count = "${module.zookeeper.zookeeper_nodes_count}"
}

data "template_file" "zookeeper_cfg_file_ids_entry_dict_list" {
  template = "$${list_of_dicts}"

  vars {
    list_of_dicts = "${join("\n", data.template_file.zookeeper_cfg_file_ids_entry_dict.*.rendered)}"
  }
}

data "template_file" "zookeeper_cfg_file_hosts_entry_dict_list" {
  template = "$${list_of_dicts}"

  vars {
    list_of_dicts = "${join("\n", formatlist("  - %s", slice(module.zookeeper.zookeeper_private_dns, 0, length(module.zookeeper.zookeeper_private_dns))))}"
  }
}

data "template_file" "ansible_inventory_zk_servers_vars_tf_managed" {
  template = "${file("templates/ansible_inventory_zk_servers_vars_tf_managed.tpl")}"

  vars {
    zookeeper_cfg_file_hosts_entries = "${data.template_file.zookeeper_cfg_file_hosts_entry_dict_list.rendered}"
  }
}

# Render ssh config file for ansible_spec
data "template_file" "ansible_spec_ssh_config" {
  template = "${file("templates/ansible_spec_ssh_config.tpl")}"

  vars {
    ssh_user              = "${var.admin_user}"
  }
}

# Configure instances and hosted services
resource "null_resource" "bastion_provisioner" {
  depends_on = [
    "module.bastion"
  ]

  triggers {
    cluster_instance_ids = "${join(",", concat(module.bastion.bastion_id, module.zookeeper.zookeeper_node_id))}"
  }

  connection {
    host = "${module.bastion.bastion_ip}"
    type = "ssh"
    user = "${var.admin_user}"
  }

  #############################################################
  # Upload and configure directories/files for Ansible
  #############################################################

  # Upload Ansible playbooks directory
  provisioner "file" {
    source      = "playbooks"
    destination = "/home/${var.admin_user}/"
  }

  # Generate Ansible hosts/inventory file from template
  provisioner "file" {
    content     = "${data.template_file.ansible_hosts.rendered}"
    destination = "/home/${var.admin_user}/playbooks/inventories/${var.ansible_inventory_name}/hosts"
  }

  # Generate Ansible inventory groups variable files from templates
  provisioner "file" {
    content     = "${data.template_file.ansible_inventory_all_vars_tf_managed.rendered}"
    destination = "/home/${var.admin_user}/playbooks/inventories/${var.ansible_inventory_name}/group_vars/all/vars_tf_managed"
  }
  provisioner "file" {
    content     = "${file(var.ansible_inventory_users_vars_file_path)}"
    destination = "/home/${var.admin_user}/playbooks/inventories/${var.ansible_inventory_name}/group_vars/all/vars_users_tf_managed"
  }
  provisioner "file" {
    content     = "${data.template_file.ansible_inventory_zk_servers_vars_tf_managed.rendered}"
    destination = "/home/${var.admin_user}/playbooks/inventories/${var.ansible_inventory_name}/group_vars/zk_servers/vars_tf_managed"
  }

  # Generate Ansible_spec configuration file for connecting via SSH
  provisioner "file" {
    content     = "${data.template_file.ansible_spec_ssh_config.rendered}"
    destination = "/home/${var.admin_user}/playbooks/.ssh/config.ansiblespec"
  }

  #############################################################
  # Install Ansible, provision and test servers
  #############################################################

  provisioner "remote-exec" {
    inline = [
      <<EOT
#!/bin/bash

## Cleanup code to run on exit (success or failure)
#function finish {
#  # Remove the uploaded deployment directories
#  sudo rm -rf "/home/${var.admin_user}/playbooks"
#}
#trap finish EXIT

# Install Ansible and dependencies
echo ""
echo "$(date) => [INFO]  => Install Ansible and dependencies."

echo "$(date) => [INFO]  => Wait for /var/lib/dpkg/lock to be released"
while (sudo lsof | awk '{print $NF}' | grep /var/lib/dpkg/lock > /dev/null 2>&1)
do
  echo '*'
  sleep 1
done

sudo apt-get update -y

echo "$(date) => [INFO]  => Wait for /var/lib/dpkg/lock to be released"
while (sudo lsof | awk '{print $NF}' | grep /var/lib/dpkg/lock > /dev/null 2>&1)
do
  echo '*'
  sleep 1
done

sudo apt-get install software-properties-common -y

echo "$(date) => [INFO]  => Wait for /var/lib/dpkg/lock to be released"
while (sudo lsof | awk '{print $NF}' | grep /var/lib/dpkg/lock > /dev/null 2>&1)
do
  echo '*'
  sleep 1
done

sudo apt-add-repository ppa:ansible/ansible -y

echo "$(date) => [INFO]  => Wait for /var/lib/dpkg/lock to be released"
while (sudo lsof | awk '{print $NF}' | grep /var/lib/dpkg/lock > /dev/null 2>&1)
do
  echo '*'
  sleep 1
done

sudo apt-get update -y

echo "$(date) => [INFO]  => Wait for /var/lib/dpkg/lock to be released"
while (sudo lsof | awk '{print $NF}' | grep /var/lib/dpkg/lock > /dev/null 2>&1)
do
  echo '*'
  sleep 1
done

sudo apt-get -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install python-jmespath python-netaddr ansible -y

# Set Ansible configuration via environment variables
echo ""
echo "$(date) => [INFO]  => Set Ansible configuration via environment variables."
export ANSIBLE_HOST_KEY_CHECKING=False

# Remove site.retry file from a previously failed Ansible run
echo ""
echo "$(date) => [INFO]  => Checking for site.retry file from a previously failed Ansible run."
test -e '/home/${var.admin_user}/playbooks/site.retry' && echo "$(date) => [INFO]  => Removing site.retry file from previously failed run."
test -e '/home/${var.admin_user}/playbooks/site.retry' && sudo rm -f '/home/${var.admin_user}/playbooks/site.retry'

# Perform Ansible playbooks validation
echo ""
echo "$(date) => [INFO]  => Perform Ansible playbooks validation."
cd /home/${var.admin_user}/playbooks/ && sudo chmod +x ./scripts/testing/playbook/playbook_validation_checks.sh
cd /home/${var.admin_user}/playbooks/ && ./scripts/testing/playbook/playbook_validation_checks.sh \
--playbook site.yml \
--inventory inventories/${var.ansible_inventory_name}/hosts \
--limit "${var.ansible_limit_value}"

# Perform Ansible run to configure VMs
echo ""
echo "$(date) => [INFO]  => Perform Ansible run to configure VMs."
cd /home/${var.admin_user}/playbooks/ && \
ansible-playbook site.yml \
--limit "${var.ansible_limit_value}" \
--inventory-file=inventories/${var.ansible_inventory_name}/hosts \
--become --user=${var.admin_user} \
${var.vmlc_stage != "VMLC.all" ? format("--tags '%s'", var.vmlc_stage) : "" } \
${var.ansible_options} \
--extra-vars 'admin_user=${var.admin_user}' \
--extra-vars 'ansible_python_interpreter=/usr/bin/python3' \
--extra-vars 'ansible_inventory_name=${var.ansible_inventory_name}' \
--extra-vars '{"suppress_zookeeper_handlers":${contains(list("true", "1"), var.suppress_zookeeper_handlers) ? "true" : "false"}}'

# Perform Ansible post-run checks for failures not indicated by return/exit code.
echo ""
echo "$(date) => [INFO]  => Perform Ansible post-run checks for failures not indicated by return/exit code."
test -e '/home/${var.admin_user}/playbooks/site.retry' && echo "$(date) => [FAILED]  => Ansible playbook run failed. See *PLAY RECAP* for further details."
test -e '/home/${var.admin_user}/playbooks/site.retry' && sudo rm -f '/home/${var.admin_user}/playbooks/site.retry' && exit 1

# Perform Ansible_spec tests to validate VMs desired state vs actual state
echo ""
echo "$(date) => [INFO]  => Perform Ansible_spec tests to validate VMs desired state vs actual state."
cd /home/${var.admin_user}/playbooks/ && sudo chmod +x ./scripts/testing/infrastructure/ansiblespec/rake_exec_ansiblespec_tasks.sh
cd /home/${var.admin_user}/playbooks/ && ./scripts/testing/infrastructure/ansiblespec/rake_exec_ansiblespec_tasks.sh \
--playbook tests/ansible_spec_tests__all.yml \
--inventory inventories/${var.ansible_inventory_name}/hosts \
--vars-dirs-path inventories/${var.ansible_inventory_name} \
--ssh-config-file .ssh/config.ansiblespec
EOT
    ]
  }
}
