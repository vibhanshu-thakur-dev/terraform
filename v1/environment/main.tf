# Adding providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    terraform = "true"
    Name      = "vibhanshu-test-vpc"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

#############
# Create Subnets within the VPC.
# A total of 3 subnets will be created
#   1. Public subnet
#   2. Private subnet
#   3. Private data subnet

# This will be replicated in 2 AZs.
###########

# 2 Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidr_list)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidr_list, count.index)
  availability_zone       = element(var.az_list, count.index % 2)
  map_public_ip_on_launch = true

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-public-subnet-${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

# 4 Private subnets
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidr_list)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnet_cidr_list, count.index)
  availability_zone       = element(var.az_list, count.index % 2)
  map_public_ip_on_launch = false

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-private-subnet-${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}


# Networking
# After subnets, an internet gateway is needed for public subnet
# to talk to the internet and for NAT gateway for private subnets.
# An elastic IP is needed for the NAT gateway


# Internet Gateway for inbound/outbound communication of elements
# in the public subnet
resource "aws_internet_gateway" "i_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-internet-gateway"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}


# Elastic IP for Internet gateway and NAT
# Two elastic IPs will be created in total, one for each NAT gateway
# 
resource "aws_eip" "eip" {
  count      = length(var.az_list)
  depends_on = [aws_internet_gateway.i_gw]
  domain     = "vpc"

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-elastic-ip-${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

# Nat gateway for each public subnet
# Two Nat gateways will be created one for subnets in each AZ
resource "aws_nat_gateway" "nat_gw" {
  count             = length(var.az_list)
  allocation_id     = element(aws_eip.eip.*.id, count.index)
  subnet_id         = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on        = [aws_internet_gateway.i_gw]
  connectivity_type = "public"


  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-nat-gateway-${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

# Route table for public subnets
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i_gw.id
  }

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-public-subnet-route-table"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}


# First public subnet being associated with the route table
resource "aws_route_table_association" "route_table_association_public_subnet_1" {
  subnet_id      = element(aws_subnet.public_subnets.*.id, 0)
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Second public subnet being associated with the route table
resource "aws_route_table_association" "route_table_association_public_subnet_2" {
  subnet_id      = element(aws_subnet.public_subnets.*.id, 1)
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
    terraform = "true"
    Name      = "vib-test-vpc-private-subnet-route-table-${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

# First public subnet being associated with the route table
resource "aws_route_table_association" "route_table_association_private_subnets" {
  count          = length(var.private_subnet_cidr_list)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_subnet_route_table.*.id, count.index % 2)
}
