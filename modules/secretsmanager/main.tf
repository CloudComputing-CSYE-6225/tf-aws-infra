resource "aws_secretsmanager_secret" "secret" {
  name                    = "${var.environment}/${var.secret_name}"
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

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_string
}