# EC2 Role that allows EC2 instances to access S3
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "${var.environment}-ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "rds.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ec2-s3-access-role"
    Environment = var.environment
  }
}

# Policy to allow EC2 to access only our specific S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.environment}-s3-access-policy"
  description = "Allow access to the application S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:PutBucketPolicy",
          "s3:PutBucketEncryption",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# Policy for RDS access
resource "aws_iam_policy" "rds_access_policy" {
  name        = "${var.environment}-rds-access-policy"
  description = "Allow RDS operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:CreateDBSubnetGroup",
          "rds:CreateDBParameterGroup",
          "rds:ModifyDBParameterGroup",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:CreateDBInstance",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:DeleteDBInstance",
          "rds:DeleteDBParameterGroup",
          "rds:DeleteDBSubnetGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Policy for IAM operations
resource "aws_iam_policy" "iam_access_policy" {
  name        = "${var.environment}-iam-access-policy"
  description = "Allow IAM operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:CreatePolicy",
          "iam:AttachRolePolicy",
          "iam:PassRole",
          "iam:CreateInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:DeleteRole",
          "iam:DetachRolePolicy",
          "iam:DeletePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Policy for KMS operations
resource "aws_iam_policy" "kms_access_policy" {
  name        = "${var.environment}-kms-access-policy"
  description = "Allow KMS operations for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Effect = "Allow"
        Resource = [
          var.ec2_kms_key_arn,
          var.rds_kms_key_arn,
          var.s3_kms_key_arn,
          var.secrets_kms_key_arn
        ]
      }
    ]
  })
}

# Policy for Secrets Manager operations
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.environment}-secrets-access-policy"
  description = "Allow Secrets Manager operations for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Policy for Auto Scaling operations
resource "aws_iam_policy" "autoscaling_access_policy" {
  name        = "${var.environment}-autoscaling-access-policy"
  description = "Allow Auto Scaling operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetInstanceHealth",
          "autoscaling:CompleteLifecycleAction"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# CloudWatch policy for metrics and logs
resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "${var.environment}-cloudwatch-policy"
  description = "Allow CloudWatch agent to publish logs and metrics"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ssm:GetParameter",
          "ssm:PutParameter"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
      }
    ]
  })
}

# Attach the RDS policy to the role
resource "aws_iam_role_policy_attachment" "rds_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.rds_access_policy.arn
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "iam_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.iam_access_policy.arn
}

# Attach the S3 policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach the KMS policy to the role
resource "aws_iam_role_policy_attachment" "kms_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}

# Attach the Secrets Manager policy to the role
resource "aws_iam_role_policy_attachment" "secrets_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}

# Attach the Auto Scaling policy to the role
resource "aws_iam_role_policy_attachment" "autoscaling_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.autoscaling_access_policy.arn
}

# Attach the CloudWatch policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

# Policy for KMS access
 resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "${var.environment}-kms-decrypt-policy"
  description = "Allow EC2 instances to decrypt using KMS keys"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = "*" 
      }
    ]
  })
}

# Attach the KMS policy to the role
resource "aws_iam_role_policy_attachment" "kms_decrypt_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}

# Add Systems Manager policy
resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.environment}-ssm-policy"
  description = "Allow EC2 instances to use Systems Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

# Create an instance profile for the role
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${var.environment}-ec2-s3-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}