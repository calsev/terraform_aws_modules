module "start_build" {
  for_each                = local.build_name_list_map
  source                  = "../iam_policy_role_code_build_project"
  access_list             = ["read_write"]
  build_project_name_list = each.value
  name                    = "${each.key}_start_build"
  std_map                 = var.std_map
}

module "site_deploy" {
  for_each = var.site_map
  source   = "../iam_policy_role_s3"
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
  source   = "../iam_policy_role_cdn"
  cdn_arn  = module.cdn.data.cdn[each.key].arn
  name     = "${each.key}_cdn_invalidate"
  std_map  = var.std_map
}

module "code_build_role" {
  for_each = var.site_map
  source   = "../iam_role_code_build"
  attach_policy_arn_map = {
    cdn_invalidate = module.cdn_invalidate[each.key].data.iam_policy_arn_map.read_write
    site_deploy    = module.site_deploy[each.key].iam_policy_arn
  }
  ci_cd_account_data = var.ci_cd_account_data
  name               = "${each.key}_deploy"
  std_map            = var.std_map
}

module "code_pipe_role" {
  for_each                = local.site_policy_map
  source                  = "../iam_role"
  assume_role_json        = var.std_map.assume_role_json.code_pipeline
  attach_policy_arn_map   = each.value.attach_policy_arn_map
  inline_policy_json_map  = each.value.inline_policy_json_map
  managed_policy_name_map = each.value.managed_policy_name_map
  name                    = "${each.key}-code-pipe"
  std_map                 = var.std_map
}
