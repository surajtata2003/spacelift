provider "aws" {
region = "ap-south-1"
}
resource "aws_instance" "example" {
ami           = "ami-02d26659fd82cf299" # Example Ubuntu AMI for ap-south-1
instance_type = "t3.micro"
tags = {
   Name = "Terraform-EC2"
}
}
