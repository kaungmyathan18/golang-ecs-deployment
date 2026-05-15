output "ecs_instances_security_group_id" {
  value = aws_security_group.ecs_instances.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
