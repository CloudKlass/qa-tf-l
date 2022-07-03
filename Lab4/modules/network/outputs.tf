
output "vpc_id" {
    description = "ID of the VPC"
    Value = aws_vpc.lab4_VPC.id
}

output "public_subnets" {
    description = "id of Public subnets"
    value = aws_subnet.public_subnet
}

output "private_subnets" {
    description = "id of private subnets"
    value = aws_subnet.private_subnet
}