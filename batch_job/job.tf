resource "aws_batch_job_definition" "this_job" {
  for_each = local.job_map
  name     = each.value.name
  container_properties = jsonencode({
    command          = each.value.command_list
    environment      = [] # TODO
    executionRoleArn = each.value.iam_role_arn_job_execution
    image            = "${each.value.image_id}:${each.value.image_tag}"
    jobRoleArn       = each.value.iam_role_arn_job_container
    linuxParameters  = local.linux_param_map[each.key]
    mountPoints = [
      for k_mount, v_mount in each.value.mount_map : {
        containerPath = v_mount.container_path
        sourceVolume  = k_mount
      }
    ]
    resourceRequirements = local.resource_requirement_map[each.key]
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
  parameters            = {} # TODO
  platform_capabilities = [] # TODO
  propagate_tags        = true
  tags                  = each.value.tags
  type                  = "container"
}
