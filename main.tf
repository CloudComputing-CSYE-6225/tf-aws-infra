module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "subnets" {
  source = "./modules/subnets"

  vpc_id               = module.vpc.vpc_id
  environment          = var.environment
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  igw_id               = module.internet_gateway.igw_id
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  application_port    = var.application_port
  ssl_certificate_arn = var.create_acm_certificate ? module.acm[0].certificate_arn : var.imported_certificate_arn
}


module "security_group" {
  source               = "./modules/security_groups"
  db_port              = var.db_port
  vpc_id               = module.vpc.vpc_id
  environment          = var.environment
  application_port     = var.application_port
  lb_security_group_id = module.load_balancer.lb_security_group_id
}

module "s3" {
  source        = "./modules/s3"
  s3_bucket_arn = module.s3.bucket_arn
  kms_key_arn   = module.kms_s3.key_arn
}

module "iam" {
  source              = "./modules/iam"
  s3_bucket_name      = module.s3.bucket_name
  environment         = var.environment
  ec2_kms_key_arn     = module.kms_ec2.key_arn
  rds_kms_key_arn     = module.kms_rds.key_arn
  s3_kms_key_arn      = module.kms_s3.key_arn
  secrets_kms_key_arn = module.kms_secretsmanager.key_arn
}

module "db_parameter_group" {
  source = "./modules/rds_parameter_group"

  environment               = var.environment
  db_parameter_group_family = var.db_parameter_group_family
}

module "rds" {
  source = "./modules/rds"

  environment             = var.environment
  private_subnet_ids      = module.subnets.private_subnet_ids
  db_security_group_id    = module.security_group.db_security_group_id
  db_parameter_group_name = module.db_parameter_group.parameter_group_name
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  db_instance_class       = var.db_instance_class
  db_password             = random_password.db_password.result
  kms_key_arn             = module.kms_rds.key_arn
}


module "auto_scaling" {
  source = "./modules/auto_scaling"

  environment           = var.environment
  custom_ami_id         = var.custom_ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  security_group_id     = module.security_group.security_group_id
  instance_profile_name = module.iam.ec2_instance_profile_name
  private_subnet_ids    = module.subnets.private_subnet_ids
  target_group_arn      = module.load_balancer.target_group_arn
  application_port      = var.application_port
  db_username           = module.rds.db_instance_username
  db_password           = random_password.db_password.result
  db_host               = replace(module.rds.db_instance_endpoint, ":5432", "")
  db_port               = var.db_port
  db_name               = module.rds.db_instance_name
  s3_bucket_name        = module.s3.bucket_name
  kms_key_arn           = module.kms_ec2.key_arn
  aws_region            = var.aws_region
}

module "route53" {
  source = "./modules/route53"

  hosted_zone_id         = var.hosted_zone_id
  domain_name            = var.domain_name
  load_balancer_dns_name = module.load_balancer.lb_dns_name
  load_balancer_zone_id  = module.load_balancer.lb_zone_id
}

module "kms_ec2" {
  source                  = "./modules/kms"
  environment             = var.environment
  key_name                = "ec2"
  description             = "KMS key for EC2 encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    rotation_period_in_days = "90"
  }
}

module "kms_rds" {
  source                  = "./modules/kms"
  environment             = var.environment
  key_name                = "rds"
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    rotation_period_in_days = "90"
  }
}

module "kms_s3" {
  source                  = "./modules/kms"
  environment             = var.environment
  key_name                = "s3"
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    rotation_period_in_days = "90"
  }
}

module "kms_secretsmanager" {
  source                  = "./modules/kms"
  environment             = var.environment
  key_name                = "secretsmanager"
  description             = "KMS key for Secrets Manager encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    rotation_period_in_days = "90"
  }
}

# Generate a random password for the database
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.environment}/db-password"
  description             = "RDS database password"
  kms_key_id              = module.kms_secretsmanager.key_arn
  recovery_window_in_days = var.recovery_window_in_days
  
  # Prevent recreation if it already exists
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [
      description,
      kms_key_id,
      recovery_window_in_days
    ]
  }

  tags = var.tags
}

# If secret exists, just update the value
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
  
  lifecycle {
    prevent_destroy = true
  }
}

module "acm" {
  source         = "./modules/acm"
  count          = var.create_acm_certificate ? 1 : 0
  domain_name    = var.domain_name
  environment    = var.environment
  hosted_zone_id = var.hosted_zone_id
}
