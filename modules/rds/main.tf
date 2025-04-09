resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier             = "csye6225"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = "csye6225"
  username               = "csye6225"
  password               = var.db_password
  parameter_group_name   = var.db_parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  storage_encrypted      = true
  kms_key_id             = var.kms_key_arn

  tags = {
    Name        = "${var.environment}-rds"
    Environment = var.environment
  }
}
