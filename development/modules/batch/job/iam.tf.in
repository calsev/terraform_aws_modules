module "container_role" {
  source                               = "../../iam/role/base"
  for_each                             = local.lx_map
  assume_role_service_list             = ["ecs-tasks"]
  map_policy                           = each.value
  name                                 = "${each.key}_job"
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
