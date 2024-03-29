resource "aws_batch_job_definition" "this_job" {
  for_each = local.job_map
  name     = each.value.name_effective
  container_properties = jsonencode({
    command = each.value.command_list
    environment = [
      for k, v in each.value.environment_map :
      {
        name  = k
        value = v
      }
    ]
    executionRoleArn = each.value.iam_role_arn_job_execution
    image            = "${each.value.image_id}:${each.value.image_tag}"
    jobRoleArn       = each.value.iam_role_arn_job_container
    linuxParameters  = each.value.linux_param_map
    mountPoints = [
      for k_mount, v_mount in each.value.mount_map : {
        containerPath = v_mount.container_path
        sourceVolume  = k_mount
      }
    ]
    resourceRequirements = each.value.requirement_list
    secrets = [
      for k, v in each.value.secret_map : {
        name      = k
        valueFrom = v
      }
    ]
    ulimits = [
      for k, v in each.value.ulimit_map : {
        hardLimit = v.hard_limit
        name      = k
        softLimit = v.soft_limit
      }
    ]
    volumes = [
      for k_mount, v_mount in each.value.mount_map : {
        host = {
          sourcePath = v_mount.source_path
        }
        name = k_mount
      }
    ]
  })
  parameters            = each.value.parameter_map
  platform_capabilities = [] # TODO
  propagate_tags        = true
  tags                  = each.value.tags
  type                  = "container"
}
