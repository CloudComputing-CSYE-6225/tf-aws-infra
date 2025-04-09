resource "aws_kms_key" "key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  key_usage               = var.key_usage

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