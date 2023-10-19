# Get AWS VPC details for EKS
data "aws_vpc" "main" {
  tags = {
    Name = "${var.vpc_name}"
  }
}

# Get VPC subnets for EKS
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Tier    = "Private"
    AZGroup = "private-subnet-group"
  }
}
