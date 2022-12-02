
##
## Virtual Private Cloud (VPC).
##
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

}

##
## Internet Gateway.
##
resource "aws_internet_gateway" "default" {
  depends_on = [aws_vpc.default]
  vpc_id = aws_vpc.default.id

}
