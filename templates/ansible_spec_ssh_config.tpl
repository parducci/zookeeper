###############################################
# SSH config file used for Ansible_spec tests #
###############################################
# NOTE: The contents of this file are managed by terraform

# Connect to remote hosts via SSH using '${ssh_user}' user
Host *
    ForwardAgent no
    ForwardX11 no
    ForwardX11Trusted yes
    User ${ssh_user}
    Port 22
    Protocol 2
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30
    IdentityFile /home/nonexistent_user_for_ansiblespec/.ssh/ceZmGbfBIgflJHmIgvVvbdQdTOzXIySH.pem
