variable "aws_region" {
  description = "Region where the state bucket and lock table will live (use the same region as backend *.hcl)."
  type        = string
  default     = "ap-southeast-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name used for S3 backend state locking (partition key must be LockID / String)."
  type        = string
  default     = "terraform-state-locks"
}

variable "enable_dynamodb_point_in_time_recovery" {
  description = "Enable DynamoDB PITR on the lock table (extra cost; usually unnecessary for lock rows only)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform-bootstrap"
    Stack     = "terraform-backend"
  }
}
