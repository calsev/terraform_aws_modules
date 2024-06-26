module "cdn_invalidate" {
  for_each = var.site_map
  source   = "../../iam/policy/identity/cdn/distribution"
  cdn_arn  = module.cdn.data[each.key].cdn_arn
  name     = "${each.key}_cdn_invalidate"
  std_map  = var.std_map
}

module "code_build_role" {
  for_each           = local.lx_map
  source             = "../../iam/role/code_build"
  ci_cd_account_data = var.ci_cd_account_data
  name               = "${each.key}_deploy"
  role_policy_attach_arn_map_default = {
    cdn_invalidate = module.cdn_invalidate[each.key].data.iam_policy_arn_map.read_write
    site_deploy    = module.cdn.data[each.key].bucket.policy.iam_policy_arn_map["write"]
  }
  std_map = var.std_map
}
