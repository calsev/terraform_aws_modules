module "code_pipe_role" {
  source                   = "../../iam/role/code_pipe"
  for_each                 = local.lx_map
  build_name_list          = local.build_name_list_map[each.key]
  deploy_group_to_app      = local.deploy_group_to_app_map[each.key]
  ci_cd_account_data       = var.ci_cd_account_data
  code_star_connection_key = var.pipe_source_code_star_connection_key_default
  name                     = "${each.key}_code_pipe"
  map_policy               = each.value
  std_map                  = var.std_map
}
