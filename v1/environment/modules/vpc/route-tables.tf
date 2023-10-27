
# Route table for public subnets
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i_gw.id
  }

  tags = {
    Name = "vib-test-vpc-public-subnet-route-table"
  }
}


# Public subnet being associated with the route table
resource "aws_route_table_association" "route_table_association_public_subnet_1" {
  count          = length(var.public_subnet_cidr_list)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Route tables for private subnets, two route tables will be created
# one for each AZ
resource "aws_route_table" "private_subnet_route_table" {
  count  = length(var.az_list)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }

  tags = {
    Name = "vib-test-vpc-private-subnet-route-table-${count.index + 1}"
  }
}

# First public subnet being associated with the route table
resource "aws_route_table_association" "route_table_association_private_subnets" {
  count          = length(var.private_subnet_cidr_list)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_subnet_route_table.*.id, count.index % 2)
}
