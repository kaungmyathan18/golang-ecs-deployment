resource "aws_ssm_parameter" "app_secrets" {
  for_each = nonsensitive(var.secrets)

  name        = "/${var.name_prefix}/${each.key}"
  description = "Secret for ${var.name_prefix}: ${each.key}"
  type        = "SecureString"
  value       = each.value

  tags = {
    Name = "${var.name_prefix}-${each.key}"
  }
}
