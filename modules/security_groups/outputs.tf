output "security_group_id" {
  value = aws_security_group.main.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}
