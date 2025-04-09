output "secret_id" {
  description = "Secret ID"
  value       = aws_secretsmanager_secret.secret.id
}

output "secret_arn" {
  description = "Secret ARN"
  value       = aws_secretsmanager_secret.secret.arn
}

output "secret_version" {
  description = "Secret Version ID"
  value       = aws_secretsmanager_secret_version.secret_version.version_id
}