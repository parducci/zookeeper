output "vpc_id" {
  value = "${aws_vpc.tfvpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.tfvpc.cidr_block}"
}

output "tfvpc-public-1-id" {
  value = "${aws_subnet.tfvpc-public-1.id}"
}

output "tfvpc-public-2-id" {
  value = "${aws_subnet.tfvpc-public-2.id}"
}

output "tfvpc-public-3-id" {
  value = "${aws_subnet.tfvpc-public-3.id}"
}

output "tfvpc-private-1-id" {
  value = "${aws_subnet.tfvpc-private-1.id}"
}

output "tfvpc-private-2-id" {
  value = "${aws_subnet.tfvpc-private-2.id}"
}

output "tfvpc-private-3-id" {
  value = "${aws_subnet.tfvpc-private-3.id}"
}
