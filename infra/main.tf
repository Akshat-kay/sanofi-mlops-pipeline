provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "ml_data" {
  bucket = "sanofi-ml-data-${var.env}"
  acl    = "private"
}
