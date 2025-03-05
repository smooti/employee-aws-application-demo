# VPC outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_id" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets_id
}

output "private_subnets_id" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.sgs.security_group_name
}

# EC2 outputs
output "instance_ip_addr" {
  description = "Public IP address of ec2 instance"
  value       = aws_instance.employee-web-app.public_ip
}