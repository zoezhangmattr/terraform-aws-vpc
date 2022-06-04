output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-subnet-ids" {
  value = { for k, v in aws_subnet.public-subnet : k => v.id }
}

output "private-subnet-ids" {
  value = { for k, v in aws_subnet.private-subnet : k => v.id }
}
