
resource "aws_instance" "slave_node" {
  depends_on = [aws_security_group.default_slave]

  # The connection block tells our provisioner how to communicate with the 
  # resource (instance).
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The path to your keyfile
    private_key = file(var.ssh_key_path)

    type = "ssh"
    host = self.public_ip
    timeout = "1m"
  }

  instance_type = var.aws_ec2_instance_type

  # Lookup the correct AMI based on the region we specified.
  ami = data.aws_ami.ubuntu.id

  tags = {
    Name    = "EC2 Slave"

  }

  # The name of our SSH key-pair.
  key_name = var.ssh_key_name

  # Our Security group to allow SSH access.
  security_groups        = [aws_security_group.default_slave.id]
  vpc_security_group_ids = [aws_security_group.default_slave.id]
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 1000
  }

  count = 2

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ${path.module}/output/slaves"
  }

}
