output "parameter_arns" {
  description = "Map of secret name to SSM parameter ARN."
  value       = { for k, p in aws_ssm_parameter.app_secrets : k => p.arn }
}
