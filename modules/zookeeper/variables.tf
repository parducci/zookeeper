variable "ami" {
  description = "AMI of bastion server"
}

variable "instance_type" {
  description = "Instance type of bastionserver"
}

variable "subnet_id" {
  description = "Bastion server subnet id"
}

variable "security_groups_ids" {
  type = "list"
  description = "Id of security group for bastion"
}

variable "key_pair_name" {
  description = "Name of the Key Pair that can be used to SSH to bastion server"
}

variable "path_to_private_key" {
  description = "Path to the private key that can be used to SSH to bastion server"
}

variable "admin_user" {
  description = "Name of the admin user"
}

variable "nodes_count" {
  description = "Number of Zookeeper Cluster Nodes"
}

variable "bastion_public_ip" {
  description = "Bastion public IP - this is used to SSH to node through Bastion"
}
