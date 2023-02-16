resource "aws_vpc" "lab4_vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = var.tag_name
  }
}

resource "aws_internet_gateway" "labigw" {
  vpc_id = aws_vpc.lab4_vpc.id

  tags = {
    Name = "Lab4_IGW"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.lab4_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_internet_gateway.labigw.id
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.prefix
 
  availability_zone_id = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.lab4_vpc.id

  tags = {
    Name = "${var.labname}-subnet-${each.key}"
  }
  # Generating a name tag for the subnets based upon an expression
}

resource "aws_subnet" "private_subnet" {
  for_each = var.prefix2
 
  availability_zone_id = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.lab4_vpc.id

  tags = {
    Name = "${var.labname}-subnet-${each.key}"
  }
}