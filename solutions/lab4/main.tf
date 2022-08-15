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

resource "aws_launch_configuration" "lab7_launchConfig" {
  name_prefix     = "lab7-aws-asg-"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  user_data       = file("userdata.sh")
  security_groups = [aws_security_group.ec2-sg-web.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "lab7_asg" {
  name                 = "lab7_asg"
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.lab7_launchConfig.name
  vpc_zone_identifier  = module.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "lab7 Autoscaling Group"
    propagate_at_launch = true
  }
}

resource "aws_lb" "lab7-elb" {
  name               = "lab7-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lab7_lb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "ALB-listener" {
  load_balancer_arn = aws_lb.lab7_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB-targetgroup.arn
  }
}

resource "aws_lb_target_group" "ALB-targetgroup" {
  name     = "Backend Target Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}


resource "aws_autoscaling_attachment" "lab7-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.lab7_asg.id
  alb_target_group_arn   = aws_lb_target_group.ALB-targetgroup.arn
}

resource "aws_security_group" "ec2-sg-web" {
  name = "aws-ec2-web-loadbalancer"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lab7_lb.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lab7_lb.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "lab7_lb" {
  name = "aws-sg-web-loadbalancer"
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