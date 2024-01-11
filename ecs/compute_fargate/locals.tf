module "name_map" {
  source   = "../../name_map"
  name_map = var.compute_map
  std_map  = var.std_map
}

locals {
  c1_map = {
    for k, v in var.compute_map : k => merge(v, module.name_map.data[k], {
      capability_type    = "FARGATE" # Consumed by ecs_task
      capacity_type      = v.capacity_type == null ? var.compute_capacity_type_default : v.capacity_type
      k_log              = "${k}_exec"
      log_retention_days = v.log_retention_days == null ? var.compute_log_retention_days_default : v.log_retention_days
    })
  }
  compute_map = {
    for k, v in var.compute_map : k => merge(local.c1_map[k])
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      capacity_provider_name = v.capacity_type
      ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k].arn
      ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k].id
      log                    = module.log_group.data[v.k_log]
    })
  }
}
