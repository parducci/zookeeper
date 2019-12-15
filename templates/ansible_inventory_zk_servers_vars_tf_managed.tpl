---
# file: vars_tf_managed
# Non-sensitive group variables and references to sensitive variables.
# NOTE: The contents of this file are managed by terraform

############################################################################
# Settings for 'pythian.zookeeper' role
############################################################################

zk_servers:
${zookeeper_cfg_file_hosts_entries}
