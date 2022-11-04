output "data" {
  value = merge(
    module.compute_common.data,
    {
      capacity_provider_name = aws_ecs_capacity_provider.this_capacity_provider.name
      ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster.id
      ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster.arn
      log_group_arn          = aws_cloudwatch_log_group.this_log_group.arn
      name                   = local.name
    }
  )
}
