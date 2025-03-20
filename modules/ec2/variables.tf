variable "public_subnet_id" {}
variable "environment" {}
variable "custom_ami_id" {}
variable "security_group_id" {}
variable "instance_type" {}
variable "instance_profile_name" {}
variable "db_endpoint" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "application_port" {}
variable "db_port" {}
variable "db_host" {}
variable "db_name" {}
variable "s3_bucket_name" {}