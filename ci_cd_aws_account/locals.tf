locals {
  base_name = "codebuild"
  bucket_data = merge(
    module.build_bucket.data[local.bucket_name],
    {
      iam_policy_arn_map = {
        for k, _ in local.bucket_policy_map : k => module.bucket_policy[k].data.iam_policy_arn
      }
      iam_policy_doc_map = {
        for k, _ in local.bucket_policy_map : k => module.bucket_policy[k].data.iam_policy_doc
      }
    },
  )
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
  log_map_base = {
    create_policy      = var.create_policy
    log_retention_days = var.log_retention_days
    policy_name_prefix = var.policy_name_prefix
  }
  log_map_private = {
    (local.base_name) = local.log_map_base
  }
  log_map = !var.log_public_enabled ? local.log_map_private : merge(local.log_map_private, {
    (local.public_name) = local.log_map_base,
  })
  output_data = {
    bucket     = local.bucket_data
    log        = module.build_log.data[local.base_name]
    log_public = var.log_public_enabled ? module.build_log.data[local.public_name] : null
    role = {
      build = {
        basic = module.basic_build_role.data
      }
    }
  }
  public_name = "${local.base_name}-public"
}
