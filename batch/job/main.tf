resource "aws_batch_job_definition" "this_job" {
  for_each              = local.job_map
  name                  = each.value.name_effective
  container_properties  = jsonencode(each.value.container_properties)
  parameters            = each.value.parameter_map
  platform_capabilities = ["EC2"] # TODO
  propagate_tags        = true
  tags                  = each.value.tags
  type                  = "container"
}
