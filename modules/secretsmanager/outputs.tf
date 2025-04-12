output "secret_id" {
  description = "Secret ID"
  value       = aws_secretsmanager_secret.secret.id
}

output "secret_arn" {
  description = "Secret ARN"
  value       = aws_secretsmanager_secret.secret.arn
}