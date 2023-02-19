locals {
  compute_map = {
    for k_comp, v in var.compute_map : k_comp => merge(v, module.compute_common.data[k_comp], {
      max_instances = v.max_instances == null ? var.compute_max_instances_default : v.max_instances
      min_instances = v.min_instances == null ? var.compute_min_instances_default : v.min_instances
    })
  }
  output_data = {
    for k_comp, v in local.compute_map : k_comp => merge(v, {
      capacity_provider_name = aws_ecs_capacity_provider.this_capacity_provider[k_comp].name
      ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k_comp].id
      ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k_comp].arn
      log_group_arn          = aws_cloudwatch_log_group.this_log_group[k_comp].arn
      }
    )
  }
}
