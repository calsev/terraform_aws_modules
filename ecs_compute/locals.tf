locals {
  compute_map = {
    for k, v in var.compute_map : k => merge(v, module.compute_common.data[k], {
      k_log              = "${k}_exec"
      log_retention_days = v.log_retention_days == null ? var.compute_log_retention_days_default : v.log_retention_days
      max_instances      = v.max_instances == null ? var.compute_max_instances_default : v.max_instances
      min_instances      = v.min_instances == null ? var.compute_min_instances_default : v.min_instances
    })
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      capacity_provider_name = aws_ecs_capacity_provider.this_capacity_provider[k].name
      ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k].id
      ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k].arn
      log                    = module.log_group.data[v.k_log]
    })
  }
}
