# https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements
# https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html

resource "aws_codebuild_project" "this_build_project" {
  for_each = local.lx_map
  artifacts {
    encryption_disabled = each.value.artifact_encryption_disabled
    location            = each.value.artifact_location
    namespace_type      = each.value.artifact_namespace_type
    packaging           = each.value.artifact_packaging
    path                = each.value.artifact_path
    type                = each.value.artifact_type
  }
  badge_enabled = each.value.badge_enabled
  build_timeout = each.value.build_timeout
  cache {
    location = each.value.cache_location
    modes    = each.value.cache_modes
    type     = each.value.cache_type
  }
  concurrent_build_limit = each.value.concurrent_build_limit
  encryption_key         = each.value.encryption_key
  environment {
    compute_type = each.value.environment_compute_type
    dynamic "environment_variable" {
      for_each = each.value.environment_variable_map
      content {
        name  = environment_variable.key
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
    }
    image                       = each.value.environment_image
    image_pull_credentials_type = each.value.environment_image_pull_credentials_type
    privileged_mode             = each.value.environment_privileged_mode
    type                        = each.value.environment_type_tag
  }
  dynamic "file_system_locations" {
    for_each = each.value.file_system_map
    content {
      identifier    = file_system_locations.key
      location      = file_system_locations.value.location
      mount_options = file_system_locations.value.mount_options
      mount_point   = file_system_locations.value.mount_point
      type          = "EFS"
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = each.value.log_group_name
      status      = each.value.log_cloudwatch_enabled ? "ENABLED" : "DISABLED"
      stream_name = null
    }
    s3_logs {
      bucket_owner_access = "FULL"
      encryption_disabled = each.value.log_s3_encryption_disabled
      location            = each.value.log_s3_bucket_location
      status              = each.value.log_s3_enabled ? "ENABLED" : "DISABLED"
    }
  }
  name                 = each.value.name
  project_visibility   = each.value.public_visibility ? "PUBLIC_READ" : "PRIVATE"
  resource_access_role = each.value.iam_role_arn_resource_access
  service_role         = each.value.iam_role_arn
  source {
    buildspec       = each.value.source_build_spec
    git_clone_depth = each.value.source_git_clone_depth
    dynamic "git_submodules_config" {
      for_each = each.value.source_type_submodules_supported ? { this = {} } : {}
      content {
        fetch_submodules = each.value.source_fetch_submodules
      }
    }
    insecure_ssl        = false
    location            = each.value.source_location
    report_build_status = each.value.source_report_build_status
    type                = each.value.source_type
  }
  source_version = each.value.source_version
  tags           = each.value.tags
  dynamic "vpc_config" {
    for_each = each.value.vpc_enabled ? { this = {} } : {}
    content {
      security_group_ids = each.value.vpc_security_group_id_list
      subnets            = each.value.vpc_subnet_id_list
      vpc_id             = each.value.vpc_id
    }
  }
}

resource "aws_codebuild_webhook" "this_web_hook" {
  for_each   = local.create_webhook_map
  build_type = "BUILD"
  dynamic "filter_group" {
    for_each = each.value.webhook_filter_map
    content {
      dynamic "filter" {
        for_each = filter_group.value
        content {
          exclude_matched_pattern = filter.value.exclude_matched_pattern
          pattern                 = filter.value.pattern
          type                    = filter.value.type
        }
      }
    }
  }
  project_name = aws_codebuild_project.this_build_project[each.value.k_map].name
}
