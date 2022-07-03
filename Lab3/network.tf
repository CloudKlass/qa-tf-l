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


resource "aws_vpc" "Lab3_VPC" {
    cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "labigw" {
  vpc_id = aws_vpc.Lab3_VPC.id

  tags = {
    Name = "Lab3_IGW"
  }
}

resource "aws_subnet" "public_subnet"{
    vpc_id     = aws_vpc.Lab3_VPC.id
    cidr_block = "10.1.1.0/24"

    tags = {
    Name = "PublicSubnet"
    }
    
}

    
resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.Lab3_VPC.id
    cidr_block = "10.1.2.0/24"

    tags = {
    Name = "PrivateSubnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.Lab3_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_internet_gateway.labigw.id
  }
}

resource "aws_eip" "static_ip" {
  vpc      = true
}

resource "aws_nat_gateway" "labnatgtw" {
  allocation_id = aws_eip.static_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Lab3_NAT_GTW"
  }

  # Ensuring IGW is created
  # Ensuring EIP is created
  depends_on = [aws_internet_gateway.labigw, aws_eip.static_ip]
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.Lab3_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_nat_gateway.labnatgtw.id
  }
}
  
resource "aws_route_table_association" "public_rta" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}
