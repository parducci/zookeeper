variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "zookeeper-dev.key"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "zookeeper-dev.key.pub"
}
variable "AMIS" {
  type = "map"
  default = {
    # Those defaults are Ubuntu 18.04 LTS Bionic hvm:ebs-ssd released 2018 Oct 12
    us-east-1     = "ami-0977029b5b13f3d08"
    us-west-2     = "ami-0f47ef92b4218ec09"
    eu-west-1     = "ami-0aebeb281fdee5054"
    eu-central-1  = "ami-0dfd7cad24d571c54"

    #us-east-1     = "ami-0ac019f4fcb7cb7e6"
    #us-west-2     = "ami-0bbe6b35405ecebdb"
    #eu-west-1     = "ami-00035f41c82244dab"
    #eu-central-1  = "ami-0bdf93799014acdc4"
  }
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "BASTION_INSTANCE_TYOPE" {
  default = "t2.micro"
}

variable "ZOOKEEPER_INSTANCE_TYPE" {
  default = "t2.medium"
}

variable "ssh_allowed_cidr" {
  default = "0.0.0.0/0"
}

variable "admin_user" {
  default = "ubuntu"
}

variable "COUNT" {
  type = "map"
  default = {
    "zookeeper-nodes" = 3
  }
}

variable "VPC_ENVIRONMENT_NAME" {
  default = "zookeeper"
}

# Virtual machine lifecycle stage
# Used to control which Ansible tasks and Ansible_spec tests are executed
# Valid values:
# - 'VMLC.all'         # Run with no affect on Ansible tasks and Ansible_spec tests
# - 'VMLC.provision'   # Install packages and deploy configs
# - 'VMLC.image_build' # Install packages
variable "vmlc_stage"                    { default = "VMLC.all" }

# Ansible options; use tfvars to target with,
# for example '--tags pythian.nifi' or '--skip-tags pythian.nifi'
variable "ansible_options"               { default = "--verbose" }

# Name of the ansible inventory to use when provisioning the VMs
variable "ansible_inventory_name"        { default = "dev" }

# Ansible option value for --limit; passed to Ansible by terraform
variable "ansible_limit_value"           { default = "all" }

# Path to an Ansible inventory vars file with settings for the pythian.instance_os_user_mgmt role
# See "./files/users/aaa_users_template.yml.example" for file structure
variable "ansible_inventory_users_vars_file_path" {}

# Set this to enable to make sure handlers which normally would start or restart zookeeper will not be executed
variable "suppress_zookeeper_handlers"   { default = "false" }
