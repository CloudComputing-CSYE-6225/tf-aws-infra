variable "aws_region" {
    description = "Defines the AWS region where the resources will be deployed"
    type = string
    default = "us-east-1" 
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_profile" { 
    description = "Specifies the AWS profile to use from your credentials file"
    type = string
    default = "dev" 
}

variable "vpc_cidr" {
    description = "Sets the CIDR block for the VPC, defining its IP range."
    type = string
    default = "10.0.0.0/16" 
}

variable "public_subnet_cidrs" {
    description = "Defines a list of CIDR blocks for public subnets"
    type = string
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
}

variable "private_subnet_cidrs" {
    description = "Defines a list of CIDR blocks for private subnets."
    type = string
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]     
}
