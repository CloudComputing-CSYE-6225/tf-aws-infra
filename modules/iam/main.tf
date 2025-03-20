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

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Create an instance profile for the role
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${var.environment}-ec2-s3-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}