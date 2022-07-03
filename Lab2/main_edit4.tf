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
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"

  depends_on = [aws_instance.SQL_Server]

  tags = {
    Name = "var.instance_name"
    KernelVers = "5.10"
    AMI_region = "Oregon"
  }
}

resource "aws_eip" "static_ip" {
  vpc      = true
  instance = aws_instance.Web_App.id
  }

resource "aws_instance" "SQL_Server" {
  ami           = "ami-0c6b9e5ead23436e4"
  instance_type = "t2.large"

  tags = {
    Name = "MS SQL Server 2017"
    Edition = "Standard"
    Windowsver = "2019"
    AMI_region = "Oregon"
  }
}
