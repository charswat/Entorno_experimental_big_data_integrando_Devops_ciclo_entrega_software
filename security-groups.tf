# Our default security group for the master nodes.
resource "aws_security_group" "default_master" {
  depends_on = [aws_vpc.default]

  name = "${var.cluster_name}-master"
  description = "Spark Security Group: Master"
  vpc_id = aws_vpc.default.id
    
  # SSH access from anywhere.
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
    
  # Outbound internet access.
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Default security group that allows to ping the instance
  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

#sparkHistory server
  ingress {
    from_port = 18080
    to_port = 18080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


#notebook
  ingress {
    from_port = 4242
    to_port = 4242
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Security group for web that allows web traffic from internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # RM in YARN mode uses 8088.
  ingress {
    from_port = 8088
    to_port = 8088
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9870
    to_port = 9870
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9001
    to_port = 9001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8089
    to_port = 8089
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Inbound TCP and UDP allowed for any server in this security group.
  ingress {
    from_port = 1
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 1
    to_port = 65535
    protocol = "udp"
    self = true
  }

}

# Our default security group for the slave nodes.
resource "aws_security_group" "default_slave" {
  depends_on = [aws_vpc.default, aws_security_group.default_master]

  name = "${var.cluster_name}-slave"
  description = "Spark Security Group: Slaves"
  vpc_id = aws_vpc.default.id

  # SSH access from anywhere.
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Inbound TCP and UDP allowed for any server in this security group.
  ingress {
    from_port = 1
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 1
    to_port = 65535
    protocol = "udp"
    self = true
  }

  # Inbound TCP and UDP allowed for any server in the master security group.
  ingress {
    from_port = 1
    to_port = 65535
    protocol = "tcp"
    security_groups = [aws_security_group.default_master.id]
  }

  ingress {
    from_port = 1
    to_port = 65535
    protocol = "udp"
    security_groups = [aws_security_group.default_master.id]
  }


}

# Inbound TCP allowed from any server in the slave security group to the master.
resource "aws_security_group_rule" "allow_all_TCP_slave_to_master" {
  depends_on = [aws_security_group.default_slave,aws_security_group.default_master]
  type = "ingress"
  from_port = 1
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.default_master.id
  source_security_group_id = aws_security_group.default_slave.id
}

# Inbound UDP allowed from any server in the slave security group to the master.
resource "aws_security_group_rule" "allow_all_UDP_slave_to_master" {
  depends_on = [aws_security_group.default_slave,aws_security_group.default_master]
  type = "ingress"
  from_port = 1
  to_port = 65535
  protocol = "udp"
  security_group_id = aws_security_group.default_master.id
  source_security_group_id = aws_security_group.default_slave.id
}
