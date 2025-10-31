provider "aws" {

  region = var.aws_region

}

resource "aws_vpc" "main_vpc" {

  cidr_block           = var.vpc_cidr

  enable_dns_support   = true

  enable_dns_hostnames = true

  tags = {

    Name = var.vpc_name

  }

}

resource "aws_subnet" "public_subnet" {

  vpc_id                  = aws_vpc.main_vpc.id

  cidr_block              = var.subnet_cidr

  map_public_ip_on_launch = true

  availability_zone       = var.availability_zone

  tags = {

    Name = var.subnet_name

  }

}

resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.main_vpc.id

  tags = {

    Name = var.igw_name

  }

}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.gw.id

  }

  tags = {

    Name = var.route_table_name

  }

}

resource "aws_route_table_association" "public_assoc" {

  subnet_id      = aws_subnet.public_subnet.id

  route_table_id = aws_route_table.public_rt.id

}

resource "aws_s3_bucket" "terraform_bucket" {

  bucket        = var.bucket_name

  force_destroy = true

  tags = {

    Name        = var.bucket_tag_name

    Environment = var.environment

  }

}
 
