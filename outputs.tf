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

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.networking.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.networking.private_route_table_id
}
