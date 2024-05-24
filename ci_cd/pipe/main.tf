resource "aws_codepipeline" "this_pipeline" {
  for_each = local.lx_map
  artifact_store {
    encryption_key {
      id   = each.value.source_artifact_encryption_key
      type = "KMS"
    }
    location = each.value.source_bucket
    region   = null # Only supported for cross-region
    type     = "S3"
  }
  role_arn      = each.value.iam_role_arn
  name          = each.value.name_effective
  pipeline_type = each.value.pipeline_type
  stage {
    action {
      category = "Source"
      name     = "Source"
      configuration = {
        BranchName           = each.value.source_branch
        ConnectionArn        = each.value.connection_arn
        DetectChanges        = each.value.source_detect_changes
        FullRepositoryId     = each.value.source_repository_id
        OutputArtifactFormat = each.value.source_artifact_format
      }
      input_artifacts = []
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      namespace = "SourceSource"
      region    = var.std_map.aws_region_name
      provider  = "CodeStarSourceConnection"
      run_order = 1
      version   = "1"
    }
    name = "Source"
  }
  dynamic "stage" {
    for_each = each.value.stage_list
    content {
      dynamic "action" {
        for_each = stage.value.action_map
        content {
          category         = action.value.category
          configuration    = action.value.configuration
          input_artifacts  = action.value.input_artifact_list
          name             = action.value.name
          output_artifacts = action.value.output_artifact_list
          owner            = action.value.owner
          namespace        = "${stage.value.name}${action.value.name}"
          provider         = action.value.provider
          region           = var.std_map.aws_region_name
          role_arn         = action.value.iam_role_arn
          run_order        = 1
          version          = action.value.version
        }
      }
      name = stage.value.name
    }
  }
  tags = each.value.tags
  dynamic "variable" {
    for_each = each.value.variable_map
    content {
      name          = each.key
      default_value = each.value
    }
  }
}

module "webhook_secret" {
  source                  = "../../secret/random"
  secret_is_param_default = var.pipe_webhook_secret_is_param_default
  secret_map              = local.create_secret_map
  std_map                 = var.std_map
}

resource "aws_codepipeline_webhook" "this_pipe_webhook" {
  for_each       = local.create_webhook_map
  authentication = "GITHUB_HMAC" # TODO: Other providers
  authentication_configuration {
    allowed_ip_range = null
    secret_token     = module.webhook_secret.secret_map[each.value.k_secret]
  }
  dynamic "filter" {
    for_each = each.value.webhook_filter_map_final
    content {
      json_path    = filter.value.json_path
      match_equals = filter.value.match_equals
    }
  }
  lifecycle {
    ignore_changes = [
      authentication_configuration[0].secret_token, # This is causing re-creation on every update
      tags,                                         # These disappear
    ]
  }
  name            = each.value.name_effective
  tags            = each.value.tags
  target_action   = "Source"
  target_pipeline = aws_codepipeline.this_pipeline[each.value.k_pipe].name
}

resource "github_repository_webhook" "this_githhub_webhook" {
  for_each   = local.create_github_map
  depends_on = [aws_codepipeline_webhook.this_pipe_webhook]
  active     = true
  configuration {
    content_type = "json"
    insecure_ssl = false
    secret       = module.webhook_secret.secret_map[each.value.k_secret]
    url          = aws_codepipeline_webhook.this_pipe_webhook[each.key].url
  }
  lifecycle {
    ignore_changes = [
      configuration[0].secret # This is causing re-creation on every update
    ]
  }
  repository = each.value.source_repository_name
  events     = each.value.webhook_event_list
}
