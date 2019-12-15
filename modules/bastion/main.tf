resource "aws_instance" "bastion" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

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
  }

  root_block_device {
    volume_size = 32
  }

  tags {
    Name = "bastion"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get upgrade -y && sudo apt-get install make -y",
      "sudo mkdir -p /home/${var.admin_user}/playbooks/inventories/${var.ansible_inventory_name}/{group_vars,host_vars}",
      "sudo chown -R ${var.admin_user}:${var.admin_user} /home/${var.admin_user}/playbooks"
    ]
  }

}
