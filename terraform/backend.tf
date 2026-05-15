# Remote state: S3 storage + DynamoDB state locking.
#
# Bootstrap first (local state in bootstrap/ creates bucket + lock table):
#   cd terraform/bootstrap
#   cp terraform.tfvars.example terraform.tfvars   # edit bucket/table names
#   terraform init && terraform apply
# Fill terraform/config/backend-*.hcl with apply outputs, then from terraform/:
#
# Backend settings cannot use Terraform variables; pass them at init time:
#   terraform init -backend-config=config/backend-dev.hcl
#   terraform init -backend-config=config/backend-prod.hcl
#
# Switching backend config after the first init may require:
#   terraform init -migrate-state -backend-config=config/backend-prod.hcl

terraform {
  backend "s3" {}
}
