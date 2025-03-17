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

module "security_group" {
  source = "./modules/security_groups"

  vpc_id           = module.vpc.vpc_id
  environment      = var.environment
  application_port = var.application_port
}

module "ec2" {
  source = "./modules/ec2"

  public_subnet_id  = module.subnets.public_subnet_ids[0]
  security_group_id = module.security_group.security_group_id
  custom_ami_id     = var.custom_ami_id
  environment       = var.environment
  instance_type     = var.instance_type
}

module "s3" {
  source = "./modules/s3"
  s3_bucket_arn = module.s3.bucket_arn
}

module "iam" {
  source       = "./modules/iam"
  s3_bucket_arn = module.s3.bucket_arn
}
