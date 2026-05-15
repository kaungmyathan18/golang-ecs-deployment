variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "container_port" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "enable_https" {
  type = bool
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener (unused when enable_https is false)."
  type        = string
  default     = ""
}
