output "zookeeper_node_id" {
  value = ["${aws_instance.zookeeper-node.*.id}"]
}

output "zookeeper_private_dns" {
  value = ["${aws_instance.zookeeper-node.*.private_dns}"]
}

output "zookeeper_nodes_count" {
  value = "${var.nodes_count}"
}

output "zookeeper_avzone" {
  value = ["${aws_instance.zookeeper-node.*.availability_zone}"]
}
