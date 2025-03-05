provider "aws" {
  region = var.region
}

# Create AWS security group
resource "aws_security_group" "ec2_sg" {
	vpc_id      = var.vpc_id
  name        = var.security_group_name
  description = var.security_group_description

  tags = {
    Name = var.security_group_name
  }
}

# Loop over ingress rules using aws_vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress_rules

  security_group_id = aws_security_group.ec2_sg.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
}

# Loop over egress rules using aws_vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.ec2_sg.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
}
