# Security group allowing internal traffic (inside VPC)
resource "aws_security_group" "internal" {
  vpc_id = "${var.vpc_id}"
  name = "internal"
  description = "Allow internal traffic"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "internal"
  }
}

# Security group allowing SSH traffic from a designated IP address (var.ssh_allowed_ip)
resource "aws_security_group" "ssh" {
  vpc_id = "${var.vpc_id}"
  name = "ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_allowed_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh"
  }
}
