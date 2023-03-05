module "bucket_policy" {
  for_each    = local.bucket_policy_map
  source      = "../iam_policy_identity_s3"
  name        = "build_bucket_${each.key}"
  name_prefix = var.policy_name_prefix
  sid_map = {
    Build = {
      access           = each.key
      bucket_name_list = [module.build_bucket.data[local.bucket_name].bucket_name]
    }
  }
  std_map = var.std_map
}

module "basic_build_role" {
  source = "../iam_role_code_build"
  ci_cd_account_data = {
    # We emulate this here of course :)
    bucket = local.bucket_data
    log    = module.build_log.data[local.base_name]
  }
  name        = "build_basic"
  name_prefix = var.policy_name_prefix
  std_map     = var.std_map
}
