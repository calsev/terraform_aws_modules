module "bucket_policy" {
  for_each    = local.bucket_policy_map
  source      = "../iam_policy_identity_s3"
  name        = "build_bucket_${each.key}"
  name_prefix = var.policy_name_prefix
  sid_map = {
    Build = {
      access           = each.key
      bucket_name_list = [module.build_bucket.data[local.bucket_name].name_effective]
    }
  }
  std_map = var.std_map
}

module "net_policy" {
  source  = "../iam_policy_identity_code_build_net"
  name    = "vpc_net"
  std_map = var.std_map
}

module "basic_build_role" {
  source = "../iam_role_code_build"
  ci_cd_account_data = {
    # We emulate this here of course :)
    bucket = local.bucket_data
    log    = module.build_log.data[local.base_name]
    policy = null
  }
  name        = "build_basic"
  name_prefix = var.policy_name_prefix
  std_map     = var.std_map
}

module "public_log_access_role" {
  for_each                 = var.log_public_enabled ? { this = {} } : {}
  source                   = "../iam_role"
  assume_role_service_list = ["codebuild"]
  name                     = "log_access_public"
  policy_attach_arn_map = {
    log = module.build_log.data[local.public_name].iam_policy_arn_map.public_read
  }
  std_map = var.std_map
}
