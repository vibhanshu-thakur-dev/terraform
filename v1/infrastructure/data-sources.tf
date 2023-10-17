# Get AWS VPC details for EKS
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Get VPC subnets for EKS
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}
