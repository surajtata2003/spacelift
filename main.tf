provider "aws" {
  region = "ap-south-1"
}

# Get existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0f031bc0fd9d687a0"
}

# Subnet in ap-south-1a
resource "aws_subnet" "subnet_a" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Example-Subnet-A"
  }
}

# Subnet in ap-south-1b
resource "aws_subnet" "subnet_b" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Example-Subnet-B"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "datasource-Terraform-internet-gateway"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow RDS access"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Subnet Group for RDS (must span 2 AZs)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS Instance (private)
resource "aws_db_instance" "example_rds" {
  identifier              = "example-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "spacelift-database"
  username                = "admin"
  password                = "YourSecurePassword123!" # Use Spacelift context or variable in production
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "Example-RDS"
  }
}
