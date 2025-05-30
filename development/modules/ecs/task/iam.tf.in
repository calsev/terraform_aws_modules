module "task_role" {
  source                               = "../../iam/role/ecs/task"
  for_each                             = local.lx_map
  ecs_exec_enabled                     = each.value.ecs_exec_enabled
  iam_data                             = var.iam_data
  log_data                             = module.task_log.data[each.key]
  name                                 = each.key
  map_policy                           = each.value
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
