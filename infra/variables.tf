variable "aws_access_key" {
  type        = string
  description = "AWS Access Key ID"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "env" {
  type        = string
  description = "Environment (dev/stage/prod)"
  default     = "dev"
}
