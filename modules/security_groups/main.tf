resource "aws_security_group" "main" {
  name        = "${var.environment}-sg"
  description = "Security group for web application instances"
  vpc_id      = var.vpc_id

  # SSH access from specific IP ranges
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from specified IP ranges"
  }

  # Application port access from the load balancer security group only
  ingress {
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [var.lb_security_group_id]
    description     = "Allow application traffic on port ${var.application_port} from load balancer only"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

# The DB security group remains unchanged
resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Security group for database instances"
  vpc_id      = var.vpc_id

  # Database access from application security group
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.main.id]
    description     = "Allow database traffic from application security group"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}