locals {
  base_name = "codebuild"
  bucket_map = {
    (local.bucket_name) = {
      lifecycle_expiration_days = var.bucket_lifecycle_expiration_days
    }
  }
  bucket_name = "build"
  log_map_base = {
    policy_create      = var.policy_create
    log_retention_days = var.log_retention_days
    policy_name_prefix = var.policy_name_prefix
  }
  log_map_private = {
    (local.base_name) = local.log_map_base
  }
  log_map = !var.log_public_enabled ? local.log_map_private : merge(local.log_map_private, {
    (local.public_name) = merge(local.log_map_base, {
      allow_public_read = true
    }),
  })
  output_data = {
    bucket     = module.build_bucket.data[local.bucket_name]
    log        = module.build_log.data[local.base_name]
    log_public = var.log_public_enabled ? module.build_log.data[local.public_name] : null
    policy = {
      vpc_net = module.net_policy.data
    }
    role = {
      build = {
        basic           = module.basic_build_role.data
        log_public_read = var.log_public_enabled ? module.public_log_access_role["this"].data : null
      }
      deploy = {
        ecs    = module.code_deploy_ecs.data
        lambda = module.code_deploy_lamba.data
      }
    }
  }
  public_name = "${local.base_name}_public"
}
