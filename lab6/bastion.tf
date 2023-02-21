
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  #[for subnet in module.vpc.public_subnets : subnet.id]
  vpc_security_group_ids = aws_security_group.allow_ssh

  tags = {
    Name = "Lab2 EC2 Web App",
    KernelVers = "4.14",
    AMI_region = "Oregon"
  }
}

resource "aws_eip" "static_ip" {
  vpc      = true
  instance = aws_instance.bastion.id
  }
 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow port 22 ssh inbound traffic"
  vpc_id      = aws_vpc.Lab3_vpc.id

  ingress {
    description      = "ssh traffic inbound"
    from_port        = 22
    to_port          = 22
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
    Name = "allow_SSH"
  }
}


# use DATA to retrive the latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*-x86_64-ebs"]     # Similar to running the CLI command: 
                                                        # aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-kernel-5.10-*-x86_64-ebs"
  }
}