output "ec2_s3_access_role" {
  value = aws_iam_role.ec2_s3_access_role
}

output "ec2_instance_profile_name" {
  description = "Name of the IAM instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_s3_profile.name
}

output "ec2_instance_profile_arn" {
  description = "ARN of the IAM instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_s3_profile.arn
}