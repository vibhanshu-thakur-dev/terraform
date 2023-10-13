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
  count = length(var.public_subnet_cidr_list)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidr_list, count.index)
  availability_zone = element(var.az_list, count.index)

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-public-subnet-az${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}

# 2 Private subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr_list)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr_list, count.index)
  availability_zone = element(var.az_list, count.index % 2)

  tags = {
    terraform = "true"
    Name      = "vib-test-vpc-private-subnet-az${count.index + 1}"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}