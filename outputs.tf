output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
   description = "List of IDs for the public subnets"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs for the private subnets"
  value       = module.subnets.private_subnet_ids
}
