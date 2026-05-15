# After `terraform apply` in terraform/bootstrap/, set bucket/dynamodb_table/region
# from outputs (or edit placeholders). Then from terraform/:
#   terraform init -backend-config=config/backend-prod.hcl

bucket         = "km-enterprise-golang-ecs-tfstate-ap-southeast-1"
key            = "golang-ecs/prod/terraform.tfstate"
region         = "ap-southeast-1"
dynamodb_table = "golang-ecs-terraform-locks"
encrypt        = true
