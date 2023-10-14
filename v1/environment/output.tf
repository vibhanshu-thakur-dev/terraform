output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc" {
  value = aws_vpc.main
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}
