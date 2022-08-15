
resource "aws_instance" "Web_App" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  #vpc_security_group_ids = ["${aws_security_group.allow_web.id}", "${aws_security_group.allow_ssh.id}"]


  tags = {
    Name = "Lab2 EC2 Web App"
    KernelVers = "5.10"
    AMI_region = "Oregon"
  }
}

resource "aws_eip" "static_ip_vm" {
  vpc      = true
  instance = aws_instance.Web_App.id
  }


