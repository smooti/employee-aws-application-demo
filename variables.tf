# General variables
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC Variables
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "demo-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# variable "enable_nat_gateway" {
#   description = "Set to true to create a NAT Gateway"
#   type        = bool
#   default     = true
# }

# Security group variables
variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "web-security-group"
}