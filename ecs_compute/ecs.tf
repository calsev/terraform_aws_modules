resource "aws_ecs_capacity_provider" "this_capacity_provider" {
  for_each = local.compute_map
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this_asg[each.key].arn
    managed_scaling {
      instance_warmup_period    = 300
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
    managed_termination_protection = "ENABLED"
  }
  name = each.value.name_effective
  tags = each.value.tags
}

module "log_group" {
  source = "../log_group"
  log_map = {
    for k, v in local.compute_map : v.k_log => v
  }
  log_create_policy_default = false
  std_map                   = var.std_map
}

resource "aws_ecs_cluster" "this_ecs_cluster" {
  for_each = local.compute_map
  configuration {
    execute_command_configuration {
      #      kms_key_id = aws_kms_key.this_kms_key.arn
      log_configuration {
        cloud_watch_log_group_name = module.log_group.data[each.value.k_log].log_group_name
      }
      logging = "OVERRIDE"
    }
  }
  name = each.value.name_effective
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = each.value.tags
}

resource "aws_ecs_cluster_capacity_providers" "this_capacity_provider" {
  for_each = local.compute_map
  capacity_providers = [
    aws_ecs_capacity_provider.this_capacity_provider[each.key].name
  ]
  cluster_name = aws_ecs_cluster.this_ecs_cluster[each.key].name
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this_capacity_provider[each.key].name
    weight            = 100
  }
}
