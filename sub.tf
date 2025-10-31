variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "Terraform-VPC"
}
variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "Terraform-public-subnet"
}
variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "ap-south-1a"
}
variable "igw_name" {
  description = "Internet Gateway name"
  type        = string
  default     = "Terraform-internet-gateway"
}
variable "route_table_name" {
  description = "Route table name"
  type        = string
  default     = "Terraform-route-table"
}
variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = "terraform-demo-bucket-assignment2-138245"
}
variable "bucket_tag_name" {
  description = "Name tag for the S3 bucket"
  type        = string
  default     = "138160-NewBucket"
}
variable "environment" {
  description = "Environment tag for the S3 bucket"
  type        = string
  default     = "Dev"
}
