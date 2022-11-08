resource "aws_ecs_task_definition" "this_task" {
  container_definitions    = jsonencode(local.container_definition_list)
  execution_role_arn       = var.iam_data.iam_role_arn_ecs_task_execution
  family                   = local.resource_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  tags                     = local.tags
  task_role_arn            = var.iam_role_arn_ecs_task
  dynamic "volume" {
    for_each = local.task_efs_map
    content {
      efs_volume_configuration {
        dynamic "authorization_config" {
          for_each = volume.value.efs_volume_configuration.authorization_config != null ? { 0 : volume.value.efs_volume_configuration.authorization_config } : {}
          content {
            access_point_id = authorization_config.value.access_point_id
            iam             = authorization_config.value.iam
          }
        }
        file_system_id     = volume.value.efs_volume_configuration.file_system_id
        root_directory     = volume.value.efs_volume_configuration.root_directory
        transit_encryption = volume.value.efs_volume_configuration.transit_encryption
      }
      name = volume.key
    }
  }
}
