resource "aws_ecs_task_definition" "this_task" {
  for_each                 = local.task_map
  container_definitions    = jsonencode(each.value.container_definition_list)
  cpu                      = each.value.resource_num_vcpu * 1024
  execution_role_arn       = var.iam_data.iam_role_arn_ecs_task_execution
  family                   = each.value.name_effective
  memory                   = each.value.resource_memory_gib * 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  tags                     = each.value.tags
  task_role_arn            = each.value.iam_role_arn
  dynamic "volume" {
    for_each = each.value.efs_volume_map
    content {
      efs_volume_configuration {
        dynamic "authorization_config" {
          for_each = volume.value.efs_volume_configuration.authorization_config != null ? { 0 : volume.value.efs_volume_configuration.authorization_config } : {}
          content {
            access_point_id = authorization_config.value.access_point_id
            iam             = authorization_config.value.iam
          }
        }
        file_system_id          = volume.value.efs_volume_configuration.file_system_id
        root_directory          = volume.value.efs_volume_configuration.root_directory
        transit_encryption      = volume.value.efs_volume_configuration.transit_encryption
        transit_encryption_port = volume.value.efs_volume_configuration.transit_encryption_port
      }
      name = volume.key
    }
  }
}
