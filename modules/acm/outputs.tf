output "certificate_arn" {
  description = "The ARN of the SSL certificate"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_validation_arn" {
  description = "The ARN of the validated SSL certificate"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}