resource "random_uuid" "bucket_name" {
}

resource "aws_s3_bucket" "assignment_bucket" {
  bucket        = random_uuid.bucket_name.result
  force_destroy = true # Allow Terraform to delete the bucket even if it's not empty
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.assignment_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Separate resource for bucket ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.assignment_bucket.id
  acl        = "private"
}

# Enable default encryption for the S3 bucket using the KMS key
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.assignment_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Create a lifecycle policy for the bucket
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.assignment_bucket.bucket

  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}