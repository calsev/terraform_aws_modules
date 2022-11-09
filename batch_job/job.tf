resource "aws_batch_job_definition" "this_job" {
  for_each = local.job_map
  name     = local.resource_name_map[each.key]
  container_properties = jsonencode({
    command              = each.value.command_list
    environment          = [] # TODO
    executionRoleArn     = each.value.iam_role_arn_job_execution
    image                = "${each.value.image_id}:${each.value.image_tag}"
    jobRoleArn           = each.value.iam_role_arn_job_container
    linuxParameters      = local.linux_param_map[each.key]
    mountPoints          = [] # TODO
    resourceRequirements = local.resource_requirement_map[each.key]
    secrets              = [] # TODO
    ulimits              = [] # TODO
    volumes              = [] # TODO
  })
  parameters            = {} # TODO
  platform_capabilities = [] # TODO
  propagate_tags        = true
  tags                  = local.tag_map[each.key]
  type                  = "container"
}
