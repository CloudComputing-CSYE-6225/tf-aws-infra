output "lb_security_group_id" {
  description = "The ID of the load balancer security group"
  value       = aws_security_group.lb_sg.id
}

output "lb_dns_name" {
  description = "The DNS name of the application load balancer"
  value       = aws_lb.webapp_lb.dns_name
}

output "lb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.webapp_lb.zone_id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.webapp_tg.arn
}