
resource "aws_instance" "master_node" {
  depends_on = [aws_instance.slave_node]

  # communicate with the resource (instance).
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The path to your keyfile
    private_key = file(var.ssh_key_path)
    type = "ssh"
    host = self.public_ip
  }

  instance_type = var.aws_ec2_instance_type
  # Lookup the correct AMI based on the region
  # we specified.
  ami = data.aws_ami.ubuntu.id

  # The name of our SSH key-pair.
  key_name = var.ssh_key_name

  # Our security group to allow SSH access.
  security_groups             = [aws_security_group.default_master.id]
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.default_master.id]
  associate_public_ip_address = true


  root_block_device {
    volume_type = "gp2"
    volume_size = 1000
  }
  tags = {
    Name    = "EC2 Master en ${aws_subnet.public.availability_zone}"

  }


  # This copies the dynamically generated list of slave node TCP/IP addresses required by  hadoop and Spark

  provisioner "file" {
    source = "${path.module}/output/slaves"
    destination = "/tmp/slaves"
  }

  # Stage and execute the master node configuration script.
   provisioner "file" {
   source = "${path.module}/shells/key-rsa-master.sh"
   destination = "/tmp/key-rsa-master.sh"
  }
  # Stage and execute the master node configuration script.
  provisioner "file" {
    source = "${path.module}/shells/start-hadoop.sh"
    destination = "/tmp/start-hadoop.sh"
  }
  provisioner "file" {
    source = "${path.module}/shells/setup-spark-jupyter.sh"
    destination = "/tmp/setup-spark-jupyter.sh"
  }
  provisioner "file" {
    source = "${path.module}/shells/sonar-project.properties"
    destination = "/home/ubuntu/sonar-project.properties"
  }
  provisioner "file" {
    source = "${path.module}/shells/build.yml"
    destination = "/home/ubuntu/build.yml"
  }
  provisioner "file" {
    source = "${path.module}/shells/continuous-delivery.sh"
    destination = "/tmp/continuous-delivery.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo echo 'export EMAIL=${var.git_user_email}' >> $HOME/.profile",
      "sudo echo 'export NAME=${var.git_user_name}' >> $HOME/.profile",
      "sudo echo 'export TOKEN=${var.github_token}' >> $HOME/.profile",
      "sudo echo 'export REPOSITORY=${var.github_repository}' >> $HOME/.profile",
      "bash /tmp/continuous-delivery.sh"

    ]
  }
  provisioner "remote-exec" {
    inline = [
      "bash /tmp/key-rsa-master.sh"

    ]
 }

  provisioner "local-exec" {

    command = "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.ssh_key_path} ubuntu@${self.public_ip}:/home/ubuntu/.ssh/id_rsa.pub ${path.module}/output/"
  }

  provisioner "local-exec" {
    command = "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.ssh_key_path} ubuntu@${self.public_ip}:/home/ubuntu/.ssh/id_rsa ${path.module}/output/"
  }


}
resource "aws_ebs_volume" "v1" {
  availability_zone= aws_subnet.public.availability_zone
  size              =  10

  tags = {
    Name = "master_vol"
  }
}

resource "null_resource" "slave_ssh_provisioner" {
  depends_on = [aws_instance.master_node]

  count = var.cluster_size
  connection {
    user = "ubuntu"
    private_key = file(var.ssh_key_path)
    type = "ssh"
    timeout = "1m"
    host = element(aws_instance.slave_node.*.public_ip, count.index)
  }

  # Send the SSH public key up to the slave and add it to the authorized_hosts file.
  provisioner "file" {
    source = "${path.module}/output/id_rsa.pub"
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
  }

  # Send the SSH private key up to the slave and add it to the authorized_hosts file.
  provisioner "file" {
    source = "${path.module}/output/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cat /home/ubuntu/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
    ]
  }


}

