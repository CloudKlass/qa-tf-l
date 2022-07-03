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

# Add the creation of the Lambda function

resource "aws_lambda_function" "hello" {
  function_name = "HelloLearners"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_upload.key

  runtime = "nodejs16.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  role = aws_iam_role.lambda_IAM.arn
}

resource "aws_cloudwatch_log_group" "hello_lambdas" {
  name = "/aws/lambda/${aws_lambda_function.hello.function_name}"

  retention_in_days = 7
}

resource "aws_iam_role" "lambda_IAM" {
  name = "IAM_lambda"

  assume_role_policy = jsonencode({ # Defining IAM role and attaching trust policy
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_IAM.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
