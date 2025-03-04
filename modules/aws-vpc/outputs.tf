output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets_id" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets_id" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# output "nat_gateway_id" {
#   description = "The ID of the NAT Gateway (if enabled)"
#   value       = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
# }
