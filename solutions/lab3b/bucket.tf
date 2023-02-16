

resource "aws_s3_bucket" "lab3bucket" {
  bucket = var.bucket_name
# if bucket is ommited, Terraform will assign a random name (lowercase) - we will pass a variable during the TF Apply stage.
  tags = {
    Name        = "My Lab bucket"
    Environment = "Lab3b"
  }
}

resource "aws_s3_bucket_acl" "Priv_acl" {
  bucket = aws_s3_bucket.lab3bucket.id
  acl    = "private"
}