resource "aws_instance" "main" {
  ami                     = var.custom_ami_id
  instance_type           = var.instance_type
  subnet_id               = var.public_subnet_id
  vpc_security_group_ids  = [var.security_group_id]
  disable_api_termination = false
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-ec2"
  }
}
