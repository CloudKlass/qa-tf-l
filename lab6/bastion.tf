
resource "aws_instance" "jump_box" {
  ami           = data.aws_ami.awslinux2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh_bh.id]

  tags = {
    Name = "Jump-Box"
    
  }
}

resource "aws_security_group" "allow_ssh_bh" { # We will use EC2 instance connect for terminal access into EKS. This requires port 22 from AWS
  name        = "allow_ssh"
  description = "Allow port 22 ssh inbound traffic"
  vpc_id      = aws_vpc.Lab6_vpc.id

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
data "aws_ami" "awslinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*-x86_64-ebs"]     # Similar to running the CLI command: 
                                                        # aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-kernel-5.10-*-x86_64-ebs"
  }
}