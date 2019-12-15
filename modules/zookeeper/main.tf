resource "aws_instance" "zookeeper-node" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  count = "${var.nodes_count}"

  # the VPC subnet
  subnet_id = "${var.subnet_id}"

  # the security group
  vpc_security_group_ids = ["${var.security_groups_ids}"]

  # the public SSH key
  key_name = "${var.key_pair_name}"

  connection {
    user = "${var.admin_user}"
    private_key = "${file("${var.path_to_private_key}")}"
    agent = false
    bastion_host = "${var.bastion_public_ip}"
    bastion_private_key = "${file("${var.path_to_private_key}")}"
    bastion_user = "${var.admin_user}"
  }

  root_block_device {
    volume_size = 32
  }

  tags {
    Name = "zookeeper-node-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get upgrade -y && sudo apt-get install make -y",
    ]
  }
}
