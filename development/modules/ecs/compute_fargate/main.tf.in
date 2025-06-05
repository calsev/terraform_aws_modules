module "log_group" {
  source                = "../../cw/log_group"
  log_map               = local.create_log_map
  policy_create_default = false
  std_map               = var.std_map
}

resource "aws_ecs_cluster" "this_ecs_cluster" {
  for_each = local.create_cluster_map
  configuration {
    execute_command_configuration {
      kms_key_id = each.value.kms_key_id_execute_command
      log_configuration {
        cloud_watch_encryption_enabled = each.value.execute_command_log_encryption_enabled
        cloud_watch_log_group_name     = each.value.execute_command_log_group_name
        s3_bucket_encryption_enabled   = false # TODO
        s3_bucket_name                 = null  # TODO
        s3_key_prefix                  = null  # TODO
      }
      logging = "OVERRIDE"
    }
  }
  name = each.value.name_effective
  dynamic "service_connect_defaults" {
    for_each = each.value.service_connect_default_namespace == null ? {} : { this = {} }
    content {
      namespace = each.value.service_connect_default_namespace
    }
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = each.value.tags
}

resource "aws_ecs_cluster_capacity_providers" "this_capacity_provider" {
  for_each = local.create_provider_map
  capacity_providers = [
    each.value.capacity_type
  ]
  cluster_name = each.value.cluster_name
  default_capacity_provider_strategy {
    capacity_provider = each.value.capacity_type
    weight            = 100
  }
}
