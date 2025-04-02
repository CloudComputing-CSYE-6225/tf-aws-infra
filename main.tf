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
  source = "./modules/load_balancer"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  application_port  = var.application_port
}


module "security_group" {
  source               = "./modules/security_groups"
  db_port              = var.db_port
  vpc_id               = module.vpc.vpc_id
  environment          = var.environment
  application_port     = var.application_port
  lb_security_group_id = module.load_balancer.lb_security_group_id
}

module "ec2" {
  source = "./modules/ec2"

  public_subnet_id      = module.subnets.public_subnet_ids[0]
  security_group_id     = module.security_group.security_group_id
  custom_ami_id         = var.custom_ami_id
  environment           = var.environment
  instance_type         = var.instance_type
  instance_profile_name = module.iam.ec2_instance_profile_name
  db_endpoint           = module.rds.db_instance_endpoint
  db_username           = module.rds.db_instance_username
  db_password           = var.db_password
  db_name               = module.rds.db_instance_name
  s3_bucket_name        = module.s3.bucket_name
  application_port      = var.application_port
  db_host               = replace(module.rds.db_instance_endpoint, ":5432", "")
  db_port               = var.db_port
}

module "s3" {
  source        = "./modules/s3"
  s3_bucket_arn = module.s3.bucket_arn
}

module "iam" {
  source         = "./modules/iam"
  s3_bucket_name = module.s3.bucket_name
  environment    = var.environment
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
  db_security_group_id    = module.security_group.db_security_group_id # Updated to use existing security group module
  db_parameter_group_name = module.db_parameter_group.parameter_group_name
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  db_instance_class       = var.db_instance_class
  db_password             = var.db_password
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
  db_password           = var.db_password
  db_host               = replace(module.rds.db_instance_endpoint, ":5432", "")
  db_port               = var.db_port
  db_name               = module.rds.db_instance_name
  s3_bucket_name        = module.s3.bucket_name
}