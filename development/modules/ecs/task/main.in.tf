module "this_event_bus" {
  source  = "../../event/bus"
  bus_map = local.create_bus_map
  std_map = var.std_map
}

module "task_log" {
  source  = "../../cw/log_group"
  log_map = local.l0_map # This is used later
  std_map = var.std_map
}

resource "aws_ecs_task_definition" "this_task" {
  for_each                 = local.lx_map
  container_definitions    = jsonencode(each.value.container_definition_list)
  cpu                      = each.value.resource_num_vcpu * 1024
  execution_role_arn       = each.value.iam_role_arn_execution
  family                   = each.value.name_effective
  memory                   = each.value.resource_memory_gib * 1024
  network_mode             = each.value.network_mode
  requires_compatibilities = [each.value.capability_type]
  tags                     = each.value.tags
  task_role_arn            = module.task_role[each.key].data.iam_role_arn
  dynamic "volume" {
    for_each = each.value.docker_volume_map
    content {
      docker_volume_configuration {
        autoprovision = volume.value.auto_provision_enabled
        driver        = volume.value.driver
        driver_opts   = volume.value.driver_option_map
        labels        = volume.value.label_map
        scope         = volume.value.scope
      }
      name = volume.key
    }
  }
  dynamic "volume" {
    for_each = each.value.efs_volume_map
    content {
      efs_volume_configuration {
        dynamic "authorization_config" {
          for_each = volume.value.authorization_access_point_id == null ? {} : { this = 0 }
          content {
            access_point_id = volume.value.authorization_access_point_id
            iam             = volume.value.authorization_iam_enabled ? "ENABLED" : "DISABLED"
          }
        }
        file_system_id          = volume.value.file_system_id
        root_directory          = volume.value.root_directory
        transit_encryption      = volume.value.transit_encryption_enabled ? "ENABLED" : "DISABLED"
        transit_encryption_port = volume.value.transit_encryption_port
      }
      name = volume.key
    }
  }
  dynamic "volume" {
    for_each = each.value.host_volume_map
    content {
      host_path = volume.value.host_path
      name      = volume.key
    }
  }
}

module "alert_trigger" {
  source                = "../../event/alert"
  alert_enabled_default = var.alert_enabled_default
  alert_level_default   = var.alert_level_default
  alert_map             = local.lx_map
  monitor_data          = var.monitor_data
  std_map               = var.std_map
}
