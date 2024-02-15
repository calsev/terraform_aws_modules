module "start_build" {
  for_each                = local.build_name_list_map
  source                  = "../../iam/policy/identity/code_build/project"
  access_list             = ["read_write"]
  build_project_name_list = each.value
  name                    = "${each.key}_start_build"
  std_map                 = var.std_map
}

module "site_deploy" {
  for_each = var.site_map
  source   = "../../iam/policy/identity/s3/bucket"
  sid_map = {
    Artifact = {
      access           = "write"
      bucket_name_list = [each.value.bucket_fqdn]
    }
  }
  name    = "${each.key}_site_deploy"
  std_map = var.std_map
}

module "cdn_invalidate" {
  for_each = var.site_map
  source   = "../../iam/policy/identity/cdn"
  cdn_arn  = module.cdn.data.cdn[each.key].arn
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
  for_each                 = local.site_policy_map
  source                   = "../../iam/role/base"
  assume_role_service_list = ["codepipeline"]
  name                     = "${each.key}-code-pipe"
  policy_attach_arn_map    = each.value.policy_attach_arn_map
  policy_inline_json_map   = each.value.policy_inline_json_map
  policy_managed_name_map  = each.value.policy_managed_name_map
  std_map                  = var.std_map
}
