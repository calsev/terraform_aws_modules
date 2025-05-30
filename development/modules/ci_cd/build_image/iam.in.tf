module "image_build_role" {
  source                               = "../../iam/role/code_build"
  for_each                             = local.lx_map
  ci_cd_account_data                   = var.ci_cd_account_data
  code_star_connection_key             = each.value.code_star_connection_key
  ecr_data_map                         = var.ecr_data_map
  map_policy                           = each.value
  name                                 = "${each.key}_build_image"
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
  vpc_access                           = each.value.vpc_access
}
