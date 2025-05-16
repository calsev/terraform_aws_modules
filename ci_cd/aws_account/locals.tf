locals {
  base_name = "codebuild"
  bucket_map = {
    (local.bucket_name) = {
      lifecycle_expiration_days         = var.bucket_lifecycle_expiration_days
      lifecycle_version_expiration_days = 1
    }
  }
  bucket_name = "build"
  log_map_base = {
    allow_public_read  = false
    log_retention_days = var.log_retention_days
  }
  log_map = merge(
    {
      (local.base_name) = local.log_map_base
    },
    var.log_public_enabled ? {
      (local.public_name) = merge(local.log_map_base, {
        allow_public_read = true
      })
    } : null
  )
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
