terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random" # Path to Docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs
      version = "~> 3.3.2"
    }
    archive = {
      source  = "hashicorp/archive" # Path to Docs: https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "bucketname" {  # Generate Random string to append to lab5 prefix
  prefix = "lab5"
  length = 6
}

resource "aws_s3_bucket" "lambda_bucket" { # Use generated string to create bucket
  bucket = random_string.bucketname.id

  acl           = "private"
  force_destroy = true
}
                                            # Create Archive to prepare for upload to Lambda service
data "archive_file" "lambda_archive" {
  type = "zip"

  source_dir  = "${path.module}/lambdaArchive" # Interpolations are wrapped in ${} and path.module represents the path to the module/folder
  output_path = "${path.module}/lambdaArchive.zip"
}

resource "aws_s3_object" "lambda_upload" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambdaArchive.zip"
  source = data.archive_file.lambda_archive.output_path

  etag = filemd5(data.archive_file.lambda_archive.output_path)
}
