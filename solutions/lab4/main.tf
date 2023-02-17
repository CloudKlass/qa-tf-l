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


module "vpc" {
  source  = "./network"

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

resource "aws_launch_template" "lab4_lt" {
  name            = "lab4-launchtemplate"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.medium"
  #user_data       = file("userdata.sh")
  user_data       = filebase64("${path.module}/userdata64.sh") #Base64 encoded version of userdata.sh
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.ec2-sg-web.id]
  }
  
  lifecycle {
    create_before_destroy = true
  }
}




resource "aws_autoscaling_group" "lab4_asg" {
  name                 = "lab4_asg"
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  launch_template {
    id      = aws_launch_template.lab4_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier  = [for subnet in module.vpc.public_subnets : subnet.id]

  tag {
    key                 = "Name"
    value               = "lab4 Autoscaling Group"
    propagate_at_launch = true
  }
}

resource "aws_lb" "lab4_elb" {
  name               = "lab4-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lab4_lb.id]
  subnets            = [for subnet in module.vpc.public_subnets : subnet.id]
}

resource "aws_lb_listener" "ALB-listener" {
  load_balancer_arn = aws_lb.lab4_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB-targetgroup.arn
  }
}

resource "aws_lb_target_group" "ALB-targetgroup" {
  name     = "BackendTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}


resource "aws_autoscaling_attachment" "lab4-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.lab4_asg.id
  alb_target_group_arn   = aws_lb_target_group.ALB-targetgroup.arn
}

resource "aws_security_group" "ec2-sg-web" {
  name = "aws-ec2-web-from-lb"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lab4_lb.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lab4_lb.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "lab4_lb" {
  name = "aws-lb-web-from-internet"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}