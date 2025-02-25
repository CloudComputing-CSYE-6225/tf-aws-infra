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

  vpc_id               = module.avpc.vpc_id
  environment          = var.environment
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  igw_id               = module.internet_gateway.igw_id
}