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

resource "aws_s3_bucket_website_configuration" "s3_web" {
  bucket = var.bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

  resource "aws_s3_object_copy" "index_copy" {
  bucket = "var.bucket_name"
  key    = "index.html"
  source = "./index.html"
# This should upload from the current directory. Therefore ensure you have the file copied into the directory that the Terraform command is executing from.
  grant {
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
    type        = "Group"
    permissions = ["READ"]
  }
}