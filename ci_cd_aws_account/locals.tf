locals {
  base_name = "codebuild"
  bucket_data = merge(module.build_bucket.data[local.bucket_name], {
    iam_policy_arn_map = {
      for k, _ in local.bucket_policy_map : k => module.bucket_policy[k].iam_policy_arn
    }
  })
  bucket_map = {
    (local.bucket_name) = {
      lifecycle_expiration_days = var.bucket_lifecycle_expiration_days
    }
  }
  bucket_name = "build"
  bucket_policy_map = {
    read       = {}
    read_write = {}
    write      = {}
  }
  output_data = {
    bucket = local.bucket_data
    log    = module.build_log.data[local.base_name]
    role = {
      build = {
        basic = module.basic_build_role.data
      }
    }
  }
}
