module "cdn_invalidate" {
  source                     = "../../iam/policy/identity/cdn/distribution"
  policy_map                 = local.create_policy_map
  policy_name_append_default = "cdn_invalidate"
  std_map                    = var.std_map
}

module "code_build_role" {
  for_each           = local.lx_map
  source             = "../../iam/role/code_build"
  ci_cd_account_data = var.ci_cd_account_data
  name               = "${each.key}_deploy"
  role_policy_attach_arn_map_default = {
    cdn_invalidate = module.cdn_invalidate.data[each.key].policy_map["read_write"].iam_policy_arn
    site_deploy    = module.cdn.data[each.key].bucket.policy.policy_map["write"].iam_policy_arn
  }
  std_map = var.std_map
}
