module "site_deploy" {
  for_each = var.site_map
  source   = "../../iam/policy/identity/s3/bucket"
  sid_map = {
    Artifact = {
      access           = "write"
      bucket_name_list = [each.value.origin_fqdn]
    }
  }
  name    = "${each.key}_site_deploy"
  std_map = var.std_map
}

module "cdn_invalidate" {
  for_each = var.site_map
  source   = "../../iam/policy/identity/cdn/distribution"
  cdn_arn  = module.cdn.data[each.key].cdn_arn
  name     = "${each.key}_cdn_invalidate"
  std_map  = var.std_map
}

module "code_build_role" {
  for_each           = var.site_map
  source             = "../../iam/role/code_build"
  ci_cd_account_data = var.ci_cd_account_data
  name               = "${each.key}_deploy"
  policy_attach_arn_map = {
    cdn_invalidate = module.cdn_invalidate[each.key].data.iam_policy_arn_map.read_write
    site_deploy    = module.site_deploy[each.key].data.iam_policy_arn
  }
  std_map = var.std_map
}

module "code_pipe_role" {
  source                   = "../../iam/role/code_pipe"
  for_each                 = var.site_map
  build_name_list          = local.build_name_list_map[each.key]
  ci_cd_account_data       = var.ci_cd_account_data
  code_star_connection_key = var.code_star_connection_key
  name                     = "${each.key}_code_pipe"
  policy_attach_arn_map    = each.value.policy_attach_arn_map
  policy_create_json_map   = each.value.policy_create_json_map
  policy_inline_json_map   = each.value.policy_inline_json_map
  policy_managed_name_map  = each.value.policy_managed_name_map
  std_map                  = var.std_map
}
