resource "aws_batch_job_definition" "this_job" {
  for_each              = local.create_job_map
  name                  = each.value.name_effective
  container_properties  = jsonencode(each.value.container_properties)
  parameters            = each.value.parameter_map
  platform_capabilities = each.value.platform_capability_list
  propagate_tags        = true
  tags                  = each.value.tags
  type                  = "container"
}

module "alert_trigger" {
  source                = "../../event/alert"
  alert_enabled_default = var.alert_enabled_default
  alert_level_default   = var.alert_level_default
  alert_map             = local.lx_map
  monitor_data          = var.monitor_data
  std_map               = var.std_map
}
