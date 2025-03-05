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

# EC2 Variables
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
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
variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "my-ec2-sg"
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for EC2 instance"
}

variable "ingress_rules" {
  description = "Map of ingress rules"
  type = map(
    object(
      {
        from_port   = number
        to_port     = number
        ip_protocol = string
        cidr_ipv4   = string
      }
    )
  )
  default = {
    ssh = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    },
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

variable "egress_rules" {
  description = "Map of egress rules"
  type = map(
    object(
      {
        from_port   = number
        to_port     = number
        ip_protocol = string
        cidr_ipv4   = string
      }
    )
  )
  default = {
    all_outbound = {
      from_port   = 0
      to_port     = 0
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}