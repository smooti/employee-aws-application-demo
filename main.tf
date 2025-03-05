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
