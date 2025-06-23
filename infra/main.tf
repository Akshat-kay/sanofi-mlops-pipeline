provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "ml_data" {
  bucket = "sanofi-ml-data-${var.env}"
  acl    = "private"
}

resource "aws_eks_cluster" "ml_inference" {
  name     = "ml-inference-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
}