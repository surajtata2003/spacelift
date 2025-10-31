provider "aws" {
  region = "ap-south-1"
}
resource "aws_vpc-spacelift" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform-VPC"
  }
}
resource "aws_subnet-spacelift" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Terraform-public-subnet"
  }
}
resource "aws_internet_gateway_spacelift" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Terraform-internet-gateway"
  }
}
resource "aws_route_table-spacelift" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Terraform-route-table"
  }
}
resource "aws_route_table_association-138160-2" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_s3_bucket" "terraform_bucket" {
  bucket        = "138160-2-terraform-demo-bucket-assignment2"
  force_destroy = true
  tags = {
    Name        = "138160-2-Terraform-S3-bucket"
    Environment = "Dev"
  }
}
