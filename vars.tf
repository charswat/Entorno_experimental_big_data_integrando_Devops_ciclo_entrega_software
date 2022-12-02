
variable "aws_access_key" {
  description = "AWS access key."
  default =" "
}

variable "aws_secret_key" {
  description = "AWS secret key."
  default =" "
}

variable "github_repository" {
  description = "Repository github"
  default =""
}
variable "github_token" {
  description = "personal access token"
  default =" "
}
variable "git_user_email" {
  description = "email."
  default =""
}

variable "git_user_name" {
  description = "user name"
  default =""
}

variable "sonar_projectKey" {
  description = "sonar project key"
  default =""
}

variable "sonar_organization" {
  description = "sonar organization"
  default =""
}

variable "ssh_key_name" {
  description = "The SSH key name to use for the instances."
  default = ""
}

variable "ssh_key_path" {
  description = "Path to the SSH private key file."
  default = ""
}


variable "vpc_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.0.0/20"
}

variable "private_subnet_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.16.0/20"
}


variable "aws_ec2_instance_type" {
  description = "AWS instance type."
  default = "t2.micro"
}

variable "cluster_name" {
  description = " name of the Spark cluster."
  default= " "
}
variable "aws_region" {
  description = "AWS region to launch servers."
  default = " "
}
variable "cluster_size" {
  description = "The size of the Spark cluster in terms of number of nodes excluding the master node."
  default = 2
}
variable "log_tfstates" {
  description = "The logs the terraform states"
  default = ""
}

