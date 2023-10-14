
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