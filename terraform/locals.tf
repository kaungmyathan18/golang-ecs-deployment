locals {
  name_prefix    = "${var.env}-${var.app_name}"
  container_name = var.app_name
  ecr_image      = "${module.ecr.repository_url}:${var.image_tag}"

  enable_domain = var.domain_name != "" && var.hosted_zone_name != ""
  enable_https  = var.enable_https && local.enable_domain

  common_tags = {
    Application = var.app_name
    Environment = var.env
    ManagedBy   = "terraform"
  }
}
