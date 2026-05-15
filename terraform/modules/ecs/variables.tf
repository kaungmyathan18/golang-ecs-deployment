variable "name_prefix" {
  type = string
}

variable "container_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "environment_variables" {
  type = map(string)
}

variable "secret_arns_by_name" {
  type    = map(string)
  default = {}
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "ecs_instance_profile_name" {
  type = string
}

variable "ecs_instances_security_group_id" {
  type = string
}

variable "ecs_tasks_security_group_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "enable_container_insights" {
  type = bool
}

variable "ecs_ami_ssm_parameter" {
  type = string
}

variable "ecs_instance_type" {
  type = string
}

variable "ecs_asg_min_size" {
  type = number
}

variable "ecs_asg_max_size" {
  type = number
}

variable "ecs_asg_desired_capacity" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "ecs_deployment" {
  description = "Rolling deployment percentages for aws_ecs_service."
  type = object({
    minimum_healthy_percent = number
    maximum_percent         = number
  })
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "alb_arn_suffix" {
  type = string
}

variable "env" {
  type = string
}
