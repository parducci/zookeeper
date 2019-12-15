output "internal_id" {
  value = "${aws_security_group.internal.id}"
}

output "ssh_id" {
  value = "${aws_security_group.ssh.id}"
}
