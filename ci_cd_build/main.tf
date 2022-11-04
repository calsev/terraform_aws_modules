# https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements
# https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html

resource "aws_codebuild_project" "this_build_project" {
  for_each = local.build_map
  artifacts {
    encryption_disabled = each.value.artifacts.encryption_disabled
    location            = each.value.artifacts.location
    namespace_type      = each.value.artifacts.namespace_type
    packaging           = each.value.artifacts.packaging
    path                = each.value.artifacts.path
    type                = each.value.artifacts.type
  }
  badge_enabled = each.value.badge_enabled
  build_timeout = each.value.build_timeout
  cache {
    location = each.value.cache.type == "S3" ? "${var.ci_cd_account_data.bucket.bucket_name}/cache/${each.value.name}" : null
    modes    = each.value.cache.type == "LOCAL" ? each.value.cache.modes : []
    type     = each.value.cache.type
  }
  concurrent_build_limit = each.value.concurrent_build_limit
  encryption_key         = "arn:${var.std_map.iam_partition}:kms:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:alias/aws/s3" # This is just the default S3 key, but keeps diffs clean
  environment {
    compute_type = each.value.environment.compute_type
    dynamic "environment_variable" {
      for_each = each.value.environment.variable_map
      content {
        name  = environment_variable.key
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
    }
    image                       = each.value.environment.image
    image_pull_credentials_type = each.value.environment.image_pull_credentials_type
    privileged_mode             = each.value.environment.privileged_mode
    type                        = each.value.environment.type
  }
  logs_config {
    cloudwatch_logs {
      group_name = var.ci_cd_account_data.log.log_group_name
      status     = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }
  name         = each.value.name
  service_role = each.value.iam_role_arn
  source {
    buildspec       = each.value.source.build_spec
    git_clone_depth = each.value.source.git_clone_depth
    dynamic "git_submodules_config" {
      for_each = contains(["CODECOMMIT", "GITHUB", "GITHUB_ENTERPRISE"], each.value.source.type) ? { this = {} } : {}
      content {
        fetch_submodules = each.value.source.fetch_submodules
      }
    }
    insecure_ssl        = false
    location            = each.value.source.location
    report_build_status = each.value.source.report_build_status
    type                = each.value.source.type
  }
  source_version = each.value.source_version
  tags           = each.value.tags
  dynamic "vpc_config" {
    for_each = each.value.vpc_config == null ? {} : { this = {} }
    content {
      security_group_ids = each.value.vpc_config.security_group_id_list
      subnets            = each.value.vpc_config.subnet_id_list
      vpc_id             = each.value.vpc_config.vpc_id
    }
  }
}

resource "aws_codebuild_webhook" "this_web_hook" {
  for_each   = local.webhook_map
  build_type = "BUILD"
  filter_group {
    dynamic "filter" {
      for_each = each.value.webhook.filter_map
      content {
        exclude_matched_pattern = filter.value.exclude_matched_pattern
        pattern                 = filter.value.pattern
        type                    = filter.value.type
      }
    }
  }
  project_name = aws_codebuild_project.this_build_project[each.value.webhook.key].name
}
