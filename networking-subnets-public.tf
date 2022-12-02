# Public subnets.
resource "aws_subnet" "public" {
  depends_on = [aws_internet_gateway.default]
  
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true

}

# Routing table for public subnet.
resource "aws_route_table" "public" {
  depends_on = [aws_internet_gateway.default]

  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_main_route_table_association" "main" {
    vpc_id = aws_vpc.default.id
    route_table_id = aws_route_table.public.id
} 

# Associate the routing table to public subnet.
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
