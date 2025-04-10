variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "ec2_kms_key_arn" {
  description = "ARN of the KMS key for EC2 encryption"
  type        = string
}

variable "rds_kms_key_arn" {
  description = "ARN of the KMS key for RDS encryption"
  type        = string
}

variable "s3_kms_key_arn" {
  description = "ARN of the KMS key for S3 encryption"
  type        = string
}

variable "secrets_kms_key_arn" {
  description = "ARN of the KMS key for Secrets Manager encryption"
  type        = string
}
