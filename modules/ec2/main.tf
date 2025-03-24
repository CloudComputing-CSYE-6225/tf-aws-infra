resource "aws_instance" "app_server" {
  ami                     = var.custom_ami_id
  instance_type           = var.instance_type
  subnet_id               = var.public_subnet_id
  vpc_security_group_ids  = [var.security_group_id]
  disable_api_termination = false
  iam_instance_profile    = var.instance_profile_name

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/userdata.tpl", {
    application_port = var.application_port
    db_username      = var.db_username
    db_password      = var.db_password
    db_host          = var.db_host
    db_port          = var.db_port
    db_name          = var.db_name
    s3_bucket_name   = var.s3_bucket_name
    environment      = var.environment
  })

  tags = {
    Name = "EC2-${var.environment}"
  }
}