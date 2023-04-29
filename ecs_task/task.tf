resource "aws_ecs_task_definition" "this_task" {
  for_each                 = local.task_map
  container_definitions    = jsonencode(each.value.container_definition_list)
  cpu                      = each.value.resource_num_vcpu * 1024
  execution_role_arn       = var.iam_data.iam_role_arn_ecs_task_execution
  family                   = each.value.name_effective
  memory                   = each.value.resource_memory_gib * 1024
  network_mode             = each.value.network_mode
  requires_compatibilities = [each.value.capability_type]
  tags                     = each.value.tags
  task_role_arn            = each.value.iam_role_arn
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
}
