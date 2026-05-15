output "state_bucket_name" {
  description = "Use as `bucket` in terraform/config/backend-*.hcl"
  value       = aws_s3_bucket.terraform_state.id
}

output "lock_table_name" {
  description = "Use as `dynamodb_table` in terraform/config/backend-*.hcl"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "aws_region" {
  description = "Use as `region` in terraform/config/backend-*.hcl"
  value       = var.aws_region
}
