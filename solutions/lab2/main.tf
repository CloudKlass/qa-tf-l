terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "Web_App" {
  ami           = "ami-0d08ef957f0e4722b"
  instance_type = "t2.micro"

  tags = {
    Name = "Lab2 EC2 Web App",
    KernelVers = "4.14",
    AMI_region = "Oregon"
  }
}
