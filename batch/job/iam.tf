module "container_role" {
  source                               = "../../iam/role/base"
  for_each                             = local.lx_map
  assume_role_service_list             = ["ecs-tasks"]
  map_policy                           = each.value
  name                                 = "${each.key}_job"
  name_include_app_fields              = each.value.name_include_app_fields
  name_override                        = each.value.name_override
  name_prefix                          = each.value.name_prefix
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  std_map                              = var.std_map
}
