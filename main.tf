# Create IAM resource
resource "aws_iam_role" "web-app" {
  name = "EmployeeWebAppRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EmployeeWebAppRole"
  }
}

resource "aws_iam_role_policy_attachment" "amazon-dynamodb-full-access" {
  role       = aws_iam_role.web-app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess" # Built-in policy
}

resource "aws_iam_role_policy_attachment" "amazon-s3-full-access" {
  role       = aws_iam_role.web-app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Built-in policy
}

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
  vpc_id                     = module.vpc.vpc_id
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  ingress_rules              = var.ingress_rules
  egress_rules               = var.egress_rules
}

# Create S3 bucket for user image storage
resource "aws_s3_bucket" "photos" {
  bucket        = "employee-photo-bucket-rko-493"
  force_destroy = true

  tags = {
    Name = "employee-photo-bucket-rko-493"
  }
}

# Creat DynamoDB table for user profile data
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "Employees"
  hash_key     = "id"              # Partition key
  billing_mode = "PAY_PER_REQUEST" # On-demand

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "Employees"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create EC2 instance
resource "aws_instance" "employee-web-app" {
  depends_on = [
    module.sgs,          # This first depends on the security group to exist
    aws_s3_bucket.photos # Where the application will store user images
  ]

  ami                         = "ami-05b10e08d247fb927" # Amazon Linux
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = aws_iam_role.web-app.name # Has Amazons S3 and Amazon DynamoDB FullAccess
  vpc_security_group_ids      = [module.sgs.security_group_id]
  subnet_id                   = module.vpc.public_subnets_id[0]
  associate_public_ip_address = true
  user_data                   = templatefile("${path.root}/resources/user-data.tftpl", { photos-bucket = aws_s3_bucket.photos.id })
  user_data_replace_on_change = true

  tags = {
    Name = "employee-web-app"
  }
}