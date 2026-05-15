variable "name_prefix" {
  type = string
}

variable "secret_parameter_arns" {
  description = "SSM parameter ARNs the ECS execution role may read (typically application secrets)."
  type        = map(string)
  default     = {}
}
