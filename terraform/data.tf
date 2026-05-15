data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "app" {
  count        = local.enable_domain ? 1 : 0
  name         = var.hosted_zone_name
  private_zone = false
}
