# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    terraform = "true"
    Name      = "vibhanshu-test-vpc"
    Email     = "${var.emailtag}"
    Owner     = "${var.emailtag}"
  }
}