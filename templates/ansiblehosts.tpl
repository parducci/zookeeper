# Ansible inventory file
# NOTE: The contents of this file are managed by terraform

#------------------------
# Child groups
#------------------------

[bastion_servers]
${bastion}

[zk_servers]
${zk-node}
