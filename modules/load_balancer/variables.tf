variable "environment" {}

variable "vpc_id" {}

variable "public_subnet_ids" {}

variable "application_port" {}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate to use with the load balancer"
  type        = string
}