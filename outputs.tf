
output "master_public_ip" {
  value = aws_instance.master_node.public_ip
}

output "yarn" {
  value = "http://${aws_instance.master_node.public_ip}:8080"
}
output "interface_hadoop_web" {
  value = "http://${aws_instance.master_node.public_ip}:9870"
}
output "interface_yarn_web" {
  value = "http://${aws_instance.master_node.public_ip}:8088/cluster/nodes"
}
output "spark_History_server" {
  value = "http://${aws_instance.master_node.public_ip}:18080"
}
output "JupiterLab" {
  value = "http://${aws_instance.master_node.public_ip}:4242"
}
output "access_key_JupiterLab" {
  value = "1234"
}


