module "vpc" {
  source = "./modules/vpc"
  environment_name = "${var.VPC_ENVIRONMENT_NAME}"
}

module "security" {
  source = "./modules/security"

  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr_block = "${module.vpc.vpc_cidr_block}"
  ssh_allowed_cidr = "${var.ssh_allowed_cidr}"
}

module "bastion" {
  source = "./modules/bastion"

  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "${var.BASTION_INSTANCE_TYOPE}"
  subnet_id = "${module.vpc.tfvpc-public-1-id}"
  security_groups_ids = "${list(module.security.ssh_id,module.security.internal_id)}"
  key_pair_name = "${aws_key_pair.mykeypair.key_name}"
  path_to_private_key = "${var.PATH_TO_PRIVATE_KEY}"
  admin_user = "${var.admin_user}"
  ansible_inventory_name = "${var.ansible_inventory_name}"
}

module "zookeeper" {
  source = "./modules/zookeeper"

  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "${var.ZOOKEEPER_INSTANCE_TYPE}"
  subnet_id = "${module.vpc.tfvpc-private-1-id}"
  security_groups_ids = "${list(module.security.ssh_id,module.security.internal_id)}"
  key_pair_name = "${aws_key_pair.mykeypair.key_name}"
  path_to_private_key = "${var.PATH_TO_PRIVATE_KEY}"
  admin_user = "${var.admin_user}"
  nodes_count = "${var.COUNT["zookeeper-nodes"]}"
  bastion_public_ip = "${element(module.bastion.bastion_ip, 0)}"
}
