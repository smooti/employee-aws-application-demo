# Create a VPC with public and private subnets spanning multiple availability zones
module "vpc" {
  source          = "./modules/aws-vpc"
  region          = var.region
  azs             = var.azs
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  # enable_nat_gateway = var.enable_nat_gateway
}

# Create security group
module "sgs" {
  source                     = "./modules/aws-sgs"
  region                     = var.region
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  ingress_rules              = var.ingress_rules
  egress_rules               = var.egress_rules
}