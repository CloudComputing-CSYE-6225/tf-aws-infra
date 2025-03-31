variable "aws_region" {
  description = "Defines the AWS region where the resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string

  default = "dev"
}

variable "aws_profile" {
  description = "Specifies the AWS profile to use from your credentials file"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Sets the CIDR block for the VPC, defining its IP range."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Defines a list of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Defines a list of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


variable "custom_ami_id" {
  description = "AMI ID of our custom image"
  type        = string
  default     = "ami-06127baa53c590f2c"
}

variable "application_port" {
  description = "Application Port"
  type        = string
  default     = "3000"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

# RDS Security Group Variables
variable "db_port" {
  description = "Database port for PostgreSQL"
  type        = number
  default     = 5432
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "csye6225"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
  # No default for security reasons - should be passed as a variable
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro" # Cheapest one as specified in requirements
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false # As per requirements
}

variable "db_publicly_accessible" {
  description = "Controls if the RDS instance should be publicly accessible"
  type        = bool
  default     = false # As per requirements
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "17.4"
}

variable "db_parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres17"
}