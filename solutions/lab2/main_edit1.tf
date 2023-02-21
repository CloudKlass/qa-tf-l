terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

# Configure the AWS Provider # Note: We will discuss more on providers shortly
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0d08ef957f0e4722b"
  instance_type = "t3.micro"

  tags = {
    Name = "Lab2 EC2 Web App",
    KernelVers = "5.10",
    AMI_region = "Oregon"
    Lab_edit = "firstChange"
  }
 }
