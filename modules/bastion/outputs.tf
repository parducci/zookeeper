output "bastion_ip" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}

output "bastion_id" {
  value = ["${aws_instance.bastion.*.id}"]
}

output "bastion_private_dns" {
  value = ["${aws_instance.bastion.*.private_dns}"]
}
