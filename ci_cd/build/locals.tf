module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_map                             = local.l0_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  create_webhook_map = {
    # The webhook is not re-created if the source changes, so encode the source in the key
    for k, v in local.lx_map : "${k}-${v.source_location}" => v if v.webhook_enabled
  }
  l0_list = flatten([
    for k_repo, v_repo in var.repo_map : [
      for k_build, v_build in v_repo.build_map : merge(
        {
          for k, v in v_repo : k => v if k != "build_map"
        },
        v_build,
        {
          k_map                   = "${k_repo}_${k_build}"
          name_include_app_fields = v_build.name_include_app_fields == null ? !strcontains(k_build, "pipe-") : v_build.name_include_app_fields
        },
      )
    ]
  ])
  l0_map = {
    for v in local.l0_list : v.k_map => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      artifact_encryption_disabled = v.artifact_encryption_disabled == null ? var.build_artifact_encryption_disabled_default : v.artifact_encryption_disabled
      artifact_location            = v.artifact_location == null ? var.build_artifact_location_default : v.artifact_location
      build_source_type            = v.source_type == null ? var.build_source_type_default : v.source_type
      build_timeout                = v.build_timeout == null ? var.build_build_timeout_default : v.build_timeout
      cache_type                   = v.cache_type == null ? var.build_cache_type_default : v.cache_type
      concurrent_build_limit       = v.concurrent_build_limit == null ? var.build_concurrent_limit_default : v.concurrent_build_limit
      encryption_key               = "arn:${var.std_map.iam_partition}:kms:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:alias/aws/s3" # This is just the default S3 key, but keeps diffs clean
      environment_image_custom     = v.environment_image_custom == null ? var.build_environment_image_custom_default : v.environment_image_custom
      environment_variable_map = merge(
        {
          AWS_DEFAULT_REGION = {
            type  = "PLAINTEXT"
            value = var.std_map.aws_region_name
          }
          CODEBUILD_CONFIG_AUTO_DISCOVER = {
            type  = "PLAINTEXT"
            value = "true"
          }
        },
        v.environment_variable_map == null ? var.build_environment_variable_map_default : v.environment_variable_map,
      )
      environment_type = v.environment_type == null ? var.build_environment_type_default : v.environment_type
      file_system_map = v.file_system_map == null ? {} : {
        for k_fs, v_fs in v.file_system_map : k_fs => merge(v_fs, {
          location_dns  = v_fs.location_dns == null ? var.build_file_system_location_dns_default : v_fs.location_dns
          location_path = v_fs.location_path == null ? var.build_file_system_location_path_default : v_fs.location_path
          mount_options = v_fs.mount_options == null ? var.build_file_system_mount_options_default : v_fs.mount_options
          mount_point   = v_fs.mount_point == null ? var.build_file_system_mount_point_default : v_fs.mount_point
        })
      }
      iam_role_arn                 = v.iam_role_arn == null ? var.build_iam_role_arn_default == null ? var.ci_cd_account_data.role.build.basic.iam_role_arn : var.build_iam_role_arn_default : v.iam_role_arn
      iam_role_arn_resource_access = v.iam_role_arn_resource_access == null ? var.build_iam_role_arn_resource_access_default : v.iam_role_arn_resource_access
      log_cloudwatch_enabled       = v.log_cloudwatch_enabled == null ? var.build_log_cloudwatch_enabled_default : v.log_cloudwatch_enabled
      log_s3_bucket_name           = v.log_s3_bucket_name == null ? var.build_log_s3_bucket_name_default : v.log_s3_bucket_name
      log_s3_enabled               = v.log_s3_enabled == null ? var.build_log_s3_enabled_default : v.log_s3_enabled
      log_s3_encryption_disabled   = v.log_s3_encryption_disabled == null ? var.build_log_s3_encryption_disabled_default : v.log_s3_encryption_disabled
      public_visibility            = v.public_visibility == null ? var.build_public_visibility_default : v.public_visibility
      source_build_spec            = v.source_build_spec == null ? var.build_source_build_spec_default : v.source_build_spec
      source_fetch_submodules      = v.source_fetch_submodules == null ? var.build_source_fetch_submodules_default : v.source_fetch_submodules
      source_version               = v.source_version == null ? var.build_source_version_default : v.source_version
      webhook_filter_map_raw       = v.webhook_filter_map == null ? var.build_webhook_filter_map_default : v.webhook_filter_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      artifact_is_pipe                        = local.l1_map[k].build_source_type == "CODEPIPELINE"
      cache_location                          = local.l1_map[k].cache_type == "S3" ? "${var.ci_cd_account_data.bucket.bucket_name}/cache/${local.l1_map[k].name_effective}" : null
      cache_modes                             = local.l1_map[k].cache_type == "LOCAL" ? v.cache_modes == null ? var.build_cache_modes_default : v.cache_modes : []
      environment_compute_type                = "BUILD_GENERAL1_${upper(split("-", local.l1_map[k].environment_type)[3])}"
      environment_image_standard              = local.compute_env_map[join("-", slice(split("-", local.l1_map[k].environment_type), 0, 3))].image
      environment_image_pull_credentials_type = local.l1_map[k].environment_image_custom == null ? "CODEBUILD" : "SERVICE_ROLE"
      environment_privileged_mode             = length(local.l1_map[k].file_system_map) > 0 ? true : v.environment_privileged_mode == null ? var.build_environment_privileged_mode_default : v.environment_privileged_mode
      environment_type_tag                    = split("-", local.l1_map[k].environment_type)[0] == "cpu" ? split("-", local.l1_map[k].environment_type)[1] == "amd" ? "LINUX_CONTAINER" : "ARM_CONTAINER" : "LINUX_GPU_CONTAINER"
      file_system_map = local.l1_map[k].file_system_map == null ? {} : {
        for k_fs, v_fs in local.l1_map[k].file_system_map : k_fs => merge(v_fs, {
          location = "${v_fs.location_dns}:/${trim(v_fs.location_path, "/")}"
        })
      }
      log_group_name             = local.l1_map[k].public_visibility ? var.ci_cd_account_data.log_public.log_group_name : var.ci_cd_account_data.log.log_group_name
      log_s3_bucket_location     = local.l1_map[k].log_s3_enabled && local.l1_map[k].log_s3_bucket_name != null ? "${local.l1_map[k].log_s3_bucket_name}/codebuild-${v.k_map}" : null
      source_no_clone            = contains(["CODEPIPELINE", "S3", "NO_SOURCE"], local.l1_map[k].build_source_type)
      source_report_build_status = local.l1_map[k].build_source_type == "CODEPIPELINE" ? false : v.source_report_build_status == null ? var.build_source_report_build_status_default : v.source_report_build_status
      source_type                = local.l1_map[k].build_source_type
      vpc_enabled                = local.l1_map[k].vpc_key != null
      webhook_filter_map = {
        for k_group, v_group in local.l1_map[k].webhook_filter_map_raw : k_group => {
          for k_filter, v_filter in v_group : k_filter => {
            exclude_matched_pattern = v_filter.exclude_matched_pattern == null ? false : v_filter.exclude_matched_pattern
            pattern                 = v_filter.pattern
            type                    = v_filter.type
          }
        }
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      artifact_is_none                 = local.l2_map[k].artifact_is_pipe ? false : v.artifact_type == null ? var.build_artifact_type_default == "NO_ARTIFACTS" : v.artifact_type == "NO_ARTIFACTS"
      artifact_type                    = local.l2_map[k].artifact_is_pipe ? "CODEPIPELINE" : v.artifact_type == null ? var.build_artifact_type_default : v.artifact_type
      badge_enabled                    = local.l2_map[k].artifact_is_pipe ? false : v.badge_enabled == null ? var.build_badge_enabled_default : v.badge_enabled # Not supported for pipe builds
      environment_image                = local.l1_map[k].environment_image_custom == null ? local.l2_map[k].environment_image_standard : local.l1_map[k].environment_image_custom
      source_git_clone_depth           = local.l2_map[k].source_no_clone ? 0 : v.source_git_clone_depth == null ? var.build_source_git_clone_depth_default : v.source_git_clone_depth
      source_location                  = local.l2_map[k].source_no_clone ? null : v.source_location == null ? v.source_location_default : v.source_location
      source_type_submodules_supported = contains(["CODECOMMIT", "GITHUB", "GITHUB_ENTERPRISE"], local.l2_map[k].source_type)
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      artifact_namespace_type = v.artifact_namespace_type == null ? local.l3_map[k].artifact_is_none ? null : local.l2_map[k].artifact_is_pipe ? "NONE" : var.build_artifact_namespace_type_default : v.artifact_namespace_type
      artifact_packaging      = v.artifact_packaging == null ? local.l3_map[k].artifact_is_none ? null : var.build_artifact_packaging_default : v.artifact_packaging
      artifact_path           = v.artifact_path == null ? local.l3_map[k].artifact_is_none ? null : var.build_artifact_path_default : v.artifact_path
      webhook_enabled         = local.l3_map[k].source_location == null ? false : v.webhook_enabled == null ? var.build_webhook_enabled_default : v.webhook_enabled
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  compute_env_map = {
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    # Ubuntu is only built for amd64: https://github.com/aws/aws-codebuild-docker-images/blob/master/ubuntu/standard/7.0/Dockerfile
    cpu-amd-amazon = {
      image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    }
    cpu-amd-ubuntu = {
      image = "aws/codebuild/standard:7.0"
    }
    cpu-arm-amazon = {
      image = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    }
    gpu-amd-ubuntu = {
      image = "aws/codebuild/standard:7.0"
    }
  }
  output_data = {
    for k_repo, v_repo in var.repo_map : k_repo => {
      for k_build, _ in v_repo.build_map : k_build => merge(
        {
          for k, v in local.lx_map["${k_repo}_${k_build}"] : k => v if !contains(["k_map", "webhook_filter_map_raw"], k)
        },
        {
          arn               = aws_codebuild_project.this_build_project["${k_repo}_${k_build}"].arn
          source_build_spec = yamldecode(local.lx_map["${k_repo}_${k_build}"].source_build_spec)
        }
      )
    }
  }
}
