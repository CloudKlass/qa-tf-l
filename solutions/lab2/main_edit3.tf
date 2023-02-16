terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
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

  depends_on = [aws_instance.SQL_Server]

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
 resource "aws_instance" "SQL_Server" {
  ami           = "ami-07c12b11bae4091a0" #Note: if 400 error is thrown choose another AMI ID (if AWS update, will no longer give access) - Browse console to find a new AMI *later we will do this dynamically through a lookup
  instance_type = "t3.xlarge" #Note: Change in AMI may require another supported instance type - Try t3.xlarge as noted here

  tags = {
    Name = "MS SQL Server 2022"
    Edition = "Standard"
    Windowsver = "2022"
    AMI_region = "Oregon"
  }
}
