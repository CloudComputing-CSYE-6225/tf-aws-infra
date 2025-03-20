output "parameter_group_id" {
  description = "The ID of the DB parameter group"
  value       = aws_db_parameter_group.main.id
}

output "parameter_group_name" {
  description = "The name of the DB parameter group"
  value       = aws_db_parameter_group.main.name
}