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