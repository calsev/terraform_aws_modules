resource "aws_ecs_capacity_provider" "this_capacity_provider" {
  for_each = local.compute_map
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this_asg[each.key].arn
    managed_scaling {
      instance_warmup_period    = each.value.auto_scaling_instance_warmup_period_s
      maximum_scaling_step_size = each.value.auto_scaling_maximum_scaling_step_size
      minimum_scaling_step_size = each.value.auto_scaling_minimum_scaling_step_size
      status                    = each.value.auto_scaling_managed_scaling_enabled ? "ENABLED" : "DISABLED"
      target_capacity           = each.value.auto_scaling_target_capacity
    }
    managed_termination_protection = each.value.auto_scaling_managed_termination_protection ? "ENABLED" : "DISABLED"
  }
  name = each.value.name_effective
  tags = each.value.tags
}

module "log_group" {
  source = "../../log_group"
  log_map = {
    for k, v in local.compute_map : v.k_log => v
  }
  policy_create_default = false
  std_map               = var.std_map
}

resource "aws_ecs_cluster" "this_ecs_cluster" {
  for_each = local.compute_map
  configuration {
    execute_command_configuration {
      #      kms_key_id = aws_kms_key.this_kms_key.arn
      log_configuration {
        cloud_watch_encryption_enabled = false # TODO
        cloud_watch_log_group_name     = module.log_group.data[each.value.k_log].log_group_name
        s3_bucket_encryption_enabled   = false # TODO
        s3_bucket_name                 = null  # TODO
        s3_key_prefix                  = null  # TODO
      }
      logging = "OVERRIDE"
    }
  }
  name = each.value.name_effective
  # service_connect_defaults # TODO
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
