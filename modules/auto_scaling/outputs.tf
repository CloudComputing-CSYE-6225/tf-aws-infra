output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.webapp.id
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.webapp_asg.name
}

output "autoscaling_group_arn" {
  description = "The ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.webapp_asg.arn
}