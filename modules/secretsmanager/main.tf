resource "aws_secretsmanager_secret" "secret" {
  name                    = var.secret_name
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    {
      Name        = "${var.environment}-${var.secret_name}"
      Environment = var.environment
    },
    var.tags
  )
}
