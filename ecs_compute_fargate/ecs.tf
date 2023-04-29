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
    each.value.capacity_type
  ]
  cluster_name = aws_ecs_cluster.this_ecs_cluster[each.key].name
  default_capacity_provider_strategy {
    capacity_provider = each.value.capacity_type
    weight            = 100
  }
}
