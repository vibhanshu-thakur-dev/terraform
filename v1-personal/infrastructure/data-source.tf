# Get AWS VPC details for EKS
data "aws_vpc" "main" {
  id = var.vpc_id
}
