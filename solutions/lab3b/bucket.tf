

resource "aws_s3_bucket" "Lab10bucket" {
  bucket = var.bucket_name
# if bucket is ommited, Terraform will assign a random name (lowercase) - we will pass a variable during the TF Apply stage.
  tags = {
    Name        = "My Lab bucket"
    Environment = "Lab10"
  }
}

resource "aws_s3_bucket_acl" "Priv_acl" {
  bucket = aws_s3_bucket.Lab10bucket.id
  acl    = "private"
}