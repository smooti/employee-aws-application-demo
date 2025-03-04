provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Create Internet Gateway for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}

# # Elastic IP for NAT Gateway (only if NAT is enabled)
# resource "aws_eip" "nat" {
#   count = var.enable_nat_gateway ? 1 : 0
# }

# # NAT Gateway (only if NAT is enabled)
# resource "aws_nat_gateway" "nat" {
#   count         = var.enable_nat_gateway ? 1 : 0
#   allocation_id = aws_eip.nat[0].id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "NAT-Gateway"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

	# Create route from internet gateway to CIDR block
  route {
		gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # # Create route to internet
  # dynamic "route" {
  #   for_each = var.enable_nat_gateway ? [1] : []
  #   content {
  #     cidr_block     = "0.0.0.0/0"
  #     nat_gateway_id = aws_nat_gateway.nat[0].id
  #   }
  # }

  tags = {
    Name = "Private-Route-Table"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
