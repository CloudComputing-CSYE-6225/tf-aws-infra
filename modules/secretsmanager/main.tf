resource "aws_secretsmanager_secret" "secret" {
  name                    = "${var.environment}-db-credentials-${formatdate("YYYYMMDD", timestamp())}"  
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days

  lifecycle {
    ignore_changes = [
      # Prevent terraform from trying to modify these after creation
      kms_key_id,
      name
    ]
  }

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

  lifecycle {
    create_before_destroy = true
  }
}