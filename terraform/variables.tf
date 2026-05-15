variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "env" {
  description = "Deployment environment name, such as dev or prod."
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name used in resource names."
  type        = string
  default     = "golang-ecs"
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 8080
}

variable "image_tag" {
  description = "Container image tag to deploy from ECR."
  type        = string
  default     = "latest"
}

variable "task_cpu" {
  description = "Task CPU units for EC2 launch type (1024 = 1 vCPU)."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Task memory reservation in MiB for EC2 launch type."
  type        = number
  default     = 512
}

variable "ecs_instance_type" {
  description = <<-EOT
    EC2 instance type for ECS container instances (EC2 launch type, awsvpc).
    t3.micro (1 GiB) is usually too small for task_memory 512 MiB plus ECS agent/OS,
    and rolling deploys can briefly need two tasks on one instance (deployment_maximum_percent > 100).
    Prefer at least t3.small for dev-sized tasks.
  EOT
  type        = string
  default     = "t3.small"
}

variable "ecs_ami_ssm_parameter" {
  description = "SSM parameter path for the ECS-optimized Amazon Linux AMI image_id."
  type        = string
  default     = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

variable "ecs_asg_desired_capacity" {
  description = "Desired number of ECS container instances in the Auto Scaling group."
  type        = number
  default     = 2
}

variable "ecs_asg_min_size" {
  description = "Minimum number of ECS container instances."
  type        = number
  default     = 1
}

variable "ecs_asg_max_size" {
  description = "Maximum number of ECS container instances."
  type        = number
  default     = 6
}

variable "desired_count" {
  description = "Initial ECS service desired task count."
  type        = number
  default     = 1
}

variable "ecs_deployment" {
  description = <<-EOT
    ECS rolling deploy settings on the ECS service (mirrors aws_ecs_service deployment_* percents).
    For desired_count = 1 on one small instance, 100%/200% can require two overlapping tasks — use minimum_healthy_percent = 0 and maximum_percent = 100 for dev-style stop-then-start.
  EOT
  type = object({
    minimum_healthy_percent = number
    maximum_percent         = number
  })
  default = {
    minimum_healthy_percent = 100
    maximum_percent         = 200
  }
}

variable "min_capacity" {
  description = "Minimum ECS service task count for autoscaling."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum ECS service task count for autoscaling."
  type        = number
  default     = 3
}

variable "health_check_path" {
  description = "Application path used by the ALB target group health check."
  type        = string
  default     = "/health"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for private subnet egress."
  type        = bool
  default     = true
}

variable "enable_container_insights" {
  description = "Whether ECS Container Insights should be enabled."
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Plaintext environment variables injected into the container."
  type        = map(string)
  default = {
    APP_ENV    = "development"
    LOG_LEVEL  = "info"
    LOG_FORMAT = "console"
  }
}

variable "secrets" {
  description = "Sensitive values stored as SSM SecureString parameters and injected into the container."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "domain_name" {
  description = "Optional DNS name for the application, such as api.example.com."
  type        = string
  default     = ""
}

variable "hosted_zone_name" {
  description = "Optional Route53 hosted zone name, such as example.com."
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Whether to create an ACM certificate and HTTPS listener. Requires domain_name and hosted_zone_name."
  type        = bool
  default     = false
}
