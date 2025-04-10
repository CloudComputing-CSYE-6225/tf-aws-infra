output "key_id" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.key.arn
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = aws_kms_key.key.arn
}

output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = aws_kms_alias.alias.arn
}

output "alias_name" {
  description = "The display name of the alias"
  value       = aws_kms_alias.alias.name
}