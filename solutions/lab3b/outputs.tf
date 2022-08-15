output "name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.Lab10bucket.id
}

output "aws_domain" {
  description = "s3 domain name"
  value       = aws_s3_bucket_website_configuration.s3_web.website_domain
}

locals {
  urls = [aws_s3_bucket.Lab10bucket.id, aws_s3_bucket_website_configuration.s3_web.website_domain]
}



output "url" {
  description = "URL of the bucket"
  value       = "${join(".",local.urls)}"
  
}