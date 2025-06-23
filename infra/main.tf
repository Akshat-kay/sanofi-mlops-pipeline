terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "sanofi-tfstate-prod"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-lock-table"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "ml_data" {
  bucket = "sanofi-ml-data-${var.env}"

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_acl" "ml_data_acl" {
  bucket = aws_s3_bucket.ml_data.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "ml_data" {
  bucket = aws_s3_bucket.ml_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "tf-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
