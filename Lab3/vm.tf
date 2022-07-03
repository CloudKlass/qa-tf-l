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
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = aws_security_group.allow_web.id

  depends_on = [aws_instance.SQL_Server]

  tags = {
    Name = "Lab2 EC2 Web App"
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
  subnet_id = aws_subnet.private_subnet
  vpc_security_group_ids = aws_security_group.allow_MSSQL.id

  tags = {
    Name = "MS SQL Server 2017"
    Edition = "Standard"
    Windowsver = "2019"
    AMI_region = "Oregon"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "allow_web_http"
  }
}

resource "aws_security_group" "allow_sql" {
  name        = "allow_sql"
  description = "Allow 1433 MS SQL inbound traffic"
  vpc_id      = aws_vpc.Lab3_VPC

  ingress {
    description      = "sql traffic inbound"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    security_groups  = [aws_security_group.allow_web]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_MSSQL"
  }
}