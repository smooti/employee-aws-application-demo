variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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
