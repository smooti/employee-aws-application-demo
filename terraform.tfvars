# General variables
region = "us-east-1"
azs    = ["us-east-1a", "us-east-1b"]

# VPC Variables
vpc_name        = "demo-vpc"
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
# enable_nat_gateway = true

# Security group variables
security_group_name        = "web-security-group"
security_group_description = "Security group for EC2 instance"
ingress_rules = {
  http = {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
  },
  https = {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
  }
}
egress_rules = {
  all_outbound = {
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    cidr_ipv4   = "0.0.0.0/0"
  }
}