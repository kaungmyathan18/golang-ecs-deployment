variable "name_prefix" {
  type = string
}

variable "secrets" {
  description = "Sensitive values stored as SSM SecureString parameters."
  type        = map(string)
  sensitive   = true
  default     = {}
}
