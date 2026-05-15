# Root module: composes infrastructure from child modules under modules/.
#
# Environment values live in config/*.tfvars (for example:
# terraform plan -var-file=config/dev.tfvars).

module "network" {
  source = "./modules/network"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  common_tags          = local.common_tags
}

module "security_groups" {
  source = "./modules/security_groups"

  name_prefix    = local.name_prefix
  vpc_id         = module.network.vpc_id
  container_port = var.container_port
  common_tags    = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  name_prefix = local.name_prefix
}

module "secrets" {
  source = "./modules/secrets"

  name_prefix = local.name_prefix
  secrets     = var.secrets
}

module "iam" {
  source = "./modules/iam"

  name_prefix           = local.name_prefix
  secret_parameter_arns = module.secrets.parameter_arns

  depends_on = [module.secrets]
}

module "acm" {
  count  = local.enable_https ? 1 : 0
  source = "./modules/acm"

  domain_name    = var.domain_name
  hosted_zone_id = data.aws_route53_zone.app[0].zone_id
}

module "alb" {
  source = "./modules/alb"

  name_prefix           = local.name_prefix
  env                   = var.env
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  container_port        = var.container_port
  health_check_path     = var.health_check_path
  enable_https          = local.enable_https
  certificate_arn       = local.enable_https ? module.acm[0].certificate_arn : ""
}

module "route53_alias" {
  source = "./modules/route53_alias"

  enable_domain  = local.enable_domain
  hosted_zone_id = local.enable_domain ? data.aws_route53_zone.app[0].zone_id : ""
  domain_name    = var.domain_name
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}

module "ecs" {
  source = "./modules/ecs"

  name_prefix                     = local.name_prefix
  container_name                  = local.container_name
  common_tags                     = local.common_tags
  container_image                 = local.ecr_image
  container_port                  = var.container_port
  task_cpu                        = var.task_cpu
  task_memory                     = var.task_memory
  environment_variables           = var.environment_variables
  secret_arns_by_name             = module.secrets.parameter_arns
  execution_role_arn              = module.iam.ecs_execution_role_arn
  task_role_arn                   = module.iam.ecs_task_role_arn
  ecs_instance_profile_name       = module.iam.ecs_instance_profile_name
  ecs_instances_security_group_id = module.security_groups.ecs_instances_security_group_id
  ecs_tasks_security_group_id     = module.security_groups.ecs_tasks_security_group_id
  private_subnet_ids              = module.network.private_subnet_ids
  target_group_arn                = module.alb.target_group_arn
  enable_container_insights       = var.enable_container_insights
  ecs_ami_ssm_parameter           = var.ecs_ami_ssm_parameter
  ecs_instance_type               = var.ecs_instance_type
  ecs_asg_min_size                = var.ecs_asg_min_size
  ecs_asg_max_size                = var.ecs_asg_max_size
  ecs_asg_desired_capacity        = var.ecs_asg_desired_capacity
  desired_count                   = var.desired_count
  ecs_deployment                  = var.ecs_deployment
  min_capacity                    = var.min_capacity
  max_capacity                    = var.max_capacity
  alb_arn_suffix                  = module.alb.alb_arn_suffix
  env                             = var.env

  depends_on = [module.alb, module.iam]
}
