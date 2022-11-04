locals {
  build_artifact_default_map = {
    for k, _ in local.build_flattened_map : k => {
      encryption_disabled = local.build_artifact_none_map[k] ? null : var.build_artifact_encryption_disabled_default
      location            = local.build_artifact_none_map[k] ? null : var.build_artifact_location_default
      namespace_type      = local.build_artifact_none_map[k] ? null : local.build_artifact_pipe_map[k] ? "NONE" : var.build_artifact_namespace_type_default
      packaging           = local.build_artifact_none_map[k] ? null : var.build_artifact_packaging_default
      path                = local.build_artifact_none_map[k] ? null : var.build_artifact_path_default
      type                = var.build_artifact_type_default
    }
  }
  build_artifact_none_map = {
    for k, v in local.build_flattened_map : k => local.build_artifact_pipe_map[k] ? false : v.artifact_type == null ? local.no_default_artifact : v.artifact_type == "NO_ARTIFACTS"
  }
  build_artifact_pipe_map = {
    for k, v in local.build_flattened_map : k => local.build_source_type_map[k] == "CODEPIPELINE"
  }
  build_environment_image_custom_map = {
    for k, v in local.build_flattened_map : k => v.environment_image_custom == null ? var.build_environment_image_custom_default : v.environment_image_custom
  }
  build_environment_image_standard_map = {
    for k, v in local.build_flattened_map : k => local.compute_env_map[join("-", slice(split("-", local.env_compute_type_map[k]), 0, 3))].image
  }
  build_flattened_list = flatten([for k_repo, repo_data in var.repo_map :
    flatten([for k_build, build in repo_data.build_map : merge({ for k, v in repo_data : k => v if k != "build_map" }, build, {
      k_map = local.build_name_map[k_repo][k_build].k_map
    })])
  ])
  build_flattened_map = {
    for b in local.build_flattened_list : b.k_map => b
  }
  build_map = {
    for k, v in local.build_flattened_map : k => {
      artifacts = {
        encryption_disabled = v.artifact_encryption_disabled == null ? local.build_artifact_default_map[k].encryption_disabled : v.artifact_encryption_disabled
        location            = v.artifact_location == null ? local.build_artifact_default_map[k].location : v.artifact_location
        namespace_type      = v.artifact_namespace_type == null ? local.build_artifact_default_map[k].namespace_type : v.artifact_namespace_type
        packaging           = v.artifact_packaging == null ? local.build_artifact_default_map[k].packaging : v.artifact_packaging
        path                = v.artifact_path == null ? local.build_artifact_default_map[k].path : v.artifact_path
        type                = local.build_artifact_pipe_map[k] ? "CODEPIPELINE" : v.artifact_type == null ? local.build_artifact_default_map[k].type : v.artifact_type
      }
      badge_enabled = local.build_artifact_pipe_map[k] ? false : v.badge_enabled == null ? var.build_badge_enabled_default : v.badge_enabled
      build_timeout = v.build_timeout == null ? var.build_build_timeout_default : v.build_timeout
      cache = {
        modes = v.cache_modes == null ? var.build_cache_modes_default : v.cache_modes
        type  = v.cache_type == null ? var.build_cache_type_default : v.cache_type
      }
      concurrent_build_limit = v.concurrent_build_limit == null ? var.build_concurrent_limit_default : v.concurrent_build_limit
      environment = {
        compute_type                = "BUILD_GENERAL1_${upper(split("-", local.env_compute_type_map[k])[3])}"
        image                       = local.build_environment_image_custom_map[k] == null ? local.build_environment_image_standard_map[k] : local.build_environment_image_custom_map[k]
        image_pull_credentials_type = local.build_environment_image_custom_map[k] == null ? "CODEBUILD" : "SERVICE_ROLE"
        privileged_mode             = v.environment_privileged_mode == null ? var.build_environment_privileged_mode_default : v.environment_privileged_mode
        type                        = split("-", local.env_compute_type_map[k])[0] == "cpu" ? split("-", local.env_compute_type_map[k])[1] == "amd" ? "LINUX_CONTAINER" : "ARM_CONTAINER" : "LINUX_GPU_CONTAINER"
        variable_map                = v.environment_variable_map == null ? {} : v.environment_variable_map
      }
      name         = v.name_override == null ? k : v.name_override # This is both the resource name in AWS and the display name in github when reporting status, so make it unique, but no prefix/suffix
      iam_role_arn = v.iam_role_arn == null ? var.build_iam_role_arn_default == null ? var.ci_cd_account_data.role.build.basic.iam_role_arn : var.build_iam_role_arn_default : v.iam_role_arn
      source = {
        build_spec          = v.source_build_spec == null ? var.build_source_build_spec_default : v.source_build_spec
        fetch_submodules    = v.source_fetch_submodules == null ? var.build_source_fetch_submodules_default : v.source_fetch_submodules
        git_clone_depth     = local.build_source_no_clone_map[k] ? 0 : v.source_git_clone_depth == null ? var.build_source_git_clone_depth_default : v.source_git_clone_depth
        location            = local.build_source_no_clone_map[k] ? null : v.source_location == null ? v.source_location_default : v.source_location
        report_build_status = local.build_source_type_map[k] == "CODEPIPELINE" ? false : v.source_report_build_status == null ? var.build_source_report_build_status_default : v.source_report_build_status
        type                = local.build_source_type_map[k]
      }
      source_version = v.source_version == null ? var.build_source_version_default : v.source_version
      tags = merge(
        var.std_map.tags,
        {
          Name = "${var.std_map.resource_name_prefix}${v.k_map}${var.std_map.resource_name_suffix}"
        }
      )
      vpc_config = v.vpc_config == null ? null : {
        security_group_id_list = v.vpc_config.security_group_id_list == null ? var.build_vpc_security_group_id_list_default : v.vpc_config.security_group_id_list
        subnet_id_list         = v.vpc_config.subnet_id_list == null ? var.build_vpc_subnet_id_list_default : v.vpc_config.subnet_id_list
        vpc_id                 = v.vpc_config.vpc_id == null ? var.build_vpc_id_default : v.vpc_config.vpc_id
      }
      webhook = v.webhook == null ? null : {
        filter_map = v.webhook.filter_map == null ? var.build_webhook_filter_map_default : {
          for k, v in v.webhook.filter_map : k => {
            exclude_matched_pattern = v.exclude_matched_pattern == null ? false : v.exclude_matched_pattern
            pattern                 = v.pattern
            type                    = v.type
          }
        }
        key = k # The webhook key encodes the source location
      }
    }
  }
  build_name_map = {
    for k_repo, repo_data in var.repo_map : k_repo => {
      for k_build, _ in repo_data.build_map : k_build => {
        k_repo  = replace(k_repo, "/[_.]/", "-")
        k_build = replace(k_build, "/[_.]/", "-")
        k_map   = "${replace(k_repo, "/[_.]/", "-")}-${replace(k_build, "/[_.]/", "-")}"
      }
    }
  }
  build_object = {
    for k_repo, repo_data in var.repo_map : k_repo => {
      for k_build, _ in repo_data.build_map : k_build => merge(
        local.build_map[local.build_name_map[k_repo][k_build].k_map],
        {
          arn = aws_codebuild_project.this_build_project[local.build_name_map[k_repo][k_build].k_map].arn
          source = merge(local.build_map[local.build_name_map[k_repo][k_build].k_map].source, {
            build_spec = yamldecode(local.build_map[local.build_name_map[k_repo][k_build].k_map].source.build_spec)
          })
        }
      )
    }
  }
  build_source_no_clone_map = {
    for k, v in local.build_flattened_map : k => contains(["CODEPIPELINE", "S3", "NO_SOURCE"], local.build_source_type_map[k])
  }
  build_source_type_map = {
    for k, v in local.build_flattened_map : k => v.source_type == null ? var.build_source_type_default : v.source_type
  }
  compute_env_map = {
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    cpu-amd-amazon = {
      image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    }
    cpu-amd-ubuntu = {
      image = "aws/codebuild/standard:6.0"
    }
    cpu-arm-amazon = {
      image = "aws/codebuild/amazonlinux2-aarch64-standard:2.0"
    }
    gpu-amd-ubuntu = {
      image = "aws/codebuild/standard:6.0"
    }
  }
  env_compute_type_map = {
    for k, v in local.build_flattened_map : k => v.environment_type == null ? var.build_environment_type_default : v.environment_type
  }
  no_default_artifact = var.build_artifact_type_default == "NO_ARTIFACTS"
  webhook_map = {
    # The webhook is not re-created if the source changes, so encode the source in the key
    for k, v in local.build_map : "${k}-${v.source.location}" => v if v.webhook != null
  }
}
