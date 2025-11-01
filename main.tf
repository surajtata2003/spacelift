provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-0f031bc0fd9d687a0"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Subnet-A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Subnet-B"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "datasource-Terraform-internet-gateway"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For testing only; restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "mysql_rds" {
  identifier              = "terraform-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "YourSecurePassword123!" # Use Spacelift secrets in production
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name = "Terraform-MySQL-RDS"
  }
}
