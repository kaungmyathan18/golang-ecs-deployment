output "aws_account_id" {
  description = "AWS account ID where resources were created."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region where resources were created."
  value       = data.aws_region.current.name
}

output "ecr_repository_url" {
  description = "ECR repository URL for application images."
  value       = module.ecr.repository_url
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = module.ecs.service_name
}

output "alb_dns_name" {
  description = "Public ALB DNS name."
  value       = module.alb.alb_dns_name
}

output "application_url" {
  description = "Best-known application URL."
  value       = local.enable_domain ? "https://${var.domain_name}" : "http://${module.alb.alb_dns_name}"
}
