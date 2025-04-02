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

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer.lb_dns_name
}

output "load_balancer_zone_id" {
  description = "Canonical hosted zone ID of the load balancer (for Route53 alias records)"
  value       = module.load_balancer.lb_zone_id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.auto_scaling.autoscaling_group_name
}