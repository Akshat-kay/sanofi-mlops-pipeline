provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key  
  secret_key = var.aws_secret_key
}


resource "aws_s3_bucket" "ml_data" {
  bucket = "sanofi-ml-data-${var.env}"
}

resource "aws_s3_bucket_acl" "ml_data_acl" {
  bucket = aws_s3_bucket.ml_data.id
  acl    = "private"
}
