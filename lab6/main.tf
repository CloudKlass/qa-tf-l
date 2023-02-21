
provider "aws" {
  region  = var.region
}


resource "aws_vpc" "Lab6_vpc" {
    cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "labigw" {
  vpc_id = aws_vpc.Lab6_vpc.id

  tags = {
    Name = "Lab6_IGW"
  }
}

resource "aws_subnet" "public_subnet"{
    vpc_id     = aws_vpc.Lab6_vpc.id
    cidr_block = "10.1.10.0/24"

    tags = {
    Name = "PublicSubnet"
    }
    
}

data "aws_availability_zones" "azlist" {
  state = "available"
}
    
resource "aws_subnet" "privatesubnets" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.Lab6_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.azlist.names[count.index]
  vpc_id            = aws_vpc.Lab6_vpc.id
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.Lab6_vpc.id

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
    Name = "Lab6_NAT_GTW"
  }

  # Ensuring IGW is created
  # Ensuring EIP is created
  depends_on = [aws_internet_gateway.labigw, aws_eip.static_ip]
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.Lab6_vpc.id

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
  count = var.az_count
  subnet_id      = "${element(aws_subnet.privatesubnets.*.id, count.index)}"
    route_table_id = aws_route_table.private_rt.id
}
