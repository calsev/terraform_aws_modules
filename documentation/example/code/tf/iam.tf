module "deps_bucket_policy" {
  source = "path/to/modules/iam/policy/identity/s3/bucket"
  name   = "dep_bucket"
  sid_map = {
    CiDeps = {
      access           = "read"
      bucket_name_list = ["cdn-bucket.example.com"]
      object_key_list  = ["installer/*"]
    }
  }
  std_map = module.com_lib.std_map
}

module "basic_build_role" {
  source             = "path/to/modules/iam/role/code_build"
  ci_cd_account_data = data.terraform_remote_state.ci_cd.outputs.data
  log_bucket_key     = "example_log_public"
  name               = "build_basic"
  role_policy_attach_arn_map_default = {
    deps_read      = module.deps_bucket_policy.data.iam_policy_arn
    efs_read_write = module.efs.data.cache.iam_policy_map["read_write"].iam_policy_arn
  }
  s3_data_map = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map     = module.com_lib.std_map
  vpc_access  = true
}

module "public_build_role" {
  source             = "path/to/modules/iam/role/code_build"
  ci_cd_account_data = data.terraform_remote_state.ci_cd.outputs.data
  log_bucket_key     = "example_log_public"
  log_public_access  = true
  name               = "build_public"
  role_policy_attach_arn_map_default = {
    deps_read      = module.deps_bucket_policy.data.iam_policy_arn
    efs_read_write = module.efs.data.cache.iam_policy_map["read_write"].iam_policy_arn
  }
  s3_data_map = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map     = module.com_lib.std_map
  vpc_access  = true
}
