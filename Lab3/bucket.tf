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

resource "aws_s3_bucket" "Lab3bucket" {
  bucket = "var.bucket_name"
# if bucket is ommited, Terraform will assign a random name (lowercase) - we will pass a variable during the TF Apply stage.
  tags = {
    Name        = "My Lab bucket"
    Environment = "Lab3"
  }
}

resource "aws_s3_bucket_acl" "Priv_acl" {
  bucket = aws_s3_bucket.Lab3bucket
  acl    = "private"
}