resource "aws_db_parameter_group" "main" {
  name   = "${var.environment}-db-parameter-group"
  family = var.db_parameter_group_family


  tags = {
    Name        = "${var.environment}-db-parameter-group"
    Environment = var.environment
  }
}