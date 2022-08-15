terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.21.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"

  tags = {
    Name = "Lab2 EC2 Web App",
    KernelVers = "5.10",
    AMI_region = "Oregon"
    Lab_edit = "firstChange"
  }
 }
resource "aws_eip" "static_ip" {
  vpc      = true
  instance = aws_instance.web.id
  }
 
