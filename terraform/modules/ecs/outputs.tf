output "cluster_arn" {
  value = aws_ecs_cluster.app.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "service_name" {
  value = aws_ecs_service.app.name
}
