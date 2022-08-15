resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.Lab10bucket.id

  acl = "public-read"
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.Lab10bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.Lab10bucket.arn,
          "${aws_s3_bucket.Lab10bucket.arn}/*",
        ]
      }
      ]
   })
   }
  
  
  
resource "aws_s3_bucket_website_configuration" "s3_web" {
  bucket = aws_s3_bucket.Lab10bucket.bucket
# if your name is not unique, or you used the name from the previous bucket task the Apply will eventually time out with error
  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "index.html"
  }
}

  resource "aws_s3_object" "index_copy" {
  bucket = "${aws_s3_bucket.Lab10bucket.id}"
  key    = "index.html"
  source = "./index.html"
  
  depends_on = [aws_s3_bucket_website_configuration.s3_web]
  content_type = "text/html"
# This should upload from the current directory. Therefore ensure you have the file copied into the directory that the Terraform command is executing from.
}