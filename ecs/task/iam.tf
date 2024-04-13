module "task_role" {
  source                               = "../../iam/role/ecs/task"
  for_each                             = local.lx_map
  log_data                             = module.task_log.data[each.key]
  name                                 = each.key
  map_policy                           = each.value
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  std_map                              = var.std_map
}
