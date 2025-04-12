data "aws_caller_identity" "current" {}

data "aws_iam_role" "autoscaling_service_role" {
  name = "AWSServiceRoleForAutoScaling"
}

resource "aws_kms_key" "key" {
  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  key_usage                = var.key_usage
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow EC2 service to use the key",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow Auto Scaling service to use the key",
        Effect = "Allow",
        Principal = {
          AWS = data.aws_iam_role.autoscaling_service_role.arn
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource = "*"
      }
    ]
  })
  tags = merge(
    {
      Name        = "${var.environment}-${var.key_name}-kms-key"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.environment}-${var.key_name}"
  target_key_id = aws_kms_key.key.key_id
}