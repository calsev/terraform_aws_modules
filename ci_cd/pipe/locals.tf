module "name_map" {
  source             = "../../name_map"
  name_infix_default = var.pipe_name_infix_default
  name_map           = local.l0_map
  std_map            = var.std_map
}

locals {
  create_github_map = {
    for k, v in local.create_webhook_map : k => v if v.webhook_enable_github_hook
  }
  create_webhook_map = {
    for k, v in local.lx_map : "${k}_${v.source_repository_id}_${v.connection_arn}" => merge(v, {
      k_pipe = k
    }) if v.webhook_enabled
  }
  l0_map = {
    for k, v in var.pipe_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      iam_role_arn                   = v.iam_role_arn == null ? var.pipe_iam_role_arn_default : v.iam_role_arn
      pipeline_type                  = v.pipeline_type == null ? var.pipe_pipeline_type_default : v.pipeline_type
      source_artifact_encryption_key = v.source_artifact_encryption_key == null ? var.pipe_source_artifact_encryption_key_default : v.source_artifact_encryption_key
      source_artifact_format         = v.source_artifact_format == null ? var.pipe_source_artifact_format_default : v.source_artifact_format
      source_branch                  = v.source_branch == null ? var.pipe_source_branch_default : v.source_branch
      source_connection_name         = v.source_connection_name == null ? var.pipe_source_connection_name_default : v.source_connection_name
      source_detect_changes          = v.source_detect_changes == null ? var.pipe_source_detect_changes_default : v.source_detect_changes
      source_repository_id           = v.source_repository_id == null ? var.pipe_source_repository_id_default : v.source_repository_id
      stage_list = [
        for i_stage, v_stage in v.stage_list : merge(v_stage, {
          action_map = {
            for k_action, v_action in v_stage.action_map : k_action => merge(v_action, {
              category = v_action.category == null ? var.pipe_stage_category_default : v_action.category
              configuration = v_action.configuration != null ? v_action.configuration : {
                EnvironmentVariables = v_action.configuration_environment_map == null ? jsonencode([]) : jsonencode([
                  for k, v in v_action.configuration_environment_map : {
                    name  = k
                    type  = v.type
                    value = v.value
                  }
                ])
                ProjectName = v_action.configuration_project_name
              }
              iam_role_arn         = v_action.iam_role_arn == null ? var.pipe_stage_iam_role_arn_default : v_action.iam_role_arn
              input_artifact_list  = v_action.input_artifact_list == null ? var.pipe_stage_input_artifact_list_default : v_action.input_artifact_list
              name                 = k_action
              output_artifact_list = concat(v_action.output_artifact == null ? [] : [v_action.output_artifact], v_action.output_artifact_list == null ? [] : v_action.output_artifact_list)
              owner                = v_action.owner == null ? var.pipe_stage_owner_default : v_action.owner
              provider             = v_action.provider == null ? var.pipe_stage_provider_default : v_action.provider
              run_order            = i_stage
              version              = v_action.version == null ? var.pipe_stage_version_default : v_action.version
            })
          }
        })
      ]
      source_bucket      = var.ci_cd_account_data.bucket.name_effective
      variable_map       = v.variable_map == null ? var.pipe_variable_map_default : v.variable_map
      webhook_enabled    = v.webhook_enabled == null ? var.pipe_webhook_enabled_default : v.webhook_enabled
      webhook_event_list = v.webhook_event_list == null ? var.pipe_webhook_event_list_default : v.webhook_event_list
      webhook_filter_map = v.webhook_filter_map == null ? var.pipe_webhook_filter_map_default : v.webhook_filter_map
      webhook_filter_map_default = {
        source_branch = {
          json_path    = "$.ref"
          match_equals = "refs/heads/{Branch}"
        }
      }
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      connection_arn             = var.ci_cd_account_data.code_star.connection[local.l1_map[k].source_connection_name].connection_arn
      webhook_enable_github_hook = local.l1_map[k].webhook_enabled ? v.webhook_enable_github_hook == null ? var.pipe_webhook_enable_github_hook_default : v.webhook_enable_github_hook : false
      webhook_filter_map_final   = merge(local.l1_map[k].webhook_filter_map_default, local.l1_map[k].webhook_filter_map)
      source_repository_name     = split("/", local.l1_map[k].source_repository_id)[1]
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        code_pipe_arn      = aws_codepipeline.this_pipeline[k].arn
        webhook_github_url = v.webhook_enable_github_hook ? github_repository_webhook.this_githhub_webhook["${k}_${v.source_repository_id}_${v.connection_arn}"].url : null
        webhook_arn        = v.webhook_enabled ? aws_codepipeline_webhook.this_pipe_webhook["${k}_${v.source_repository_id}_${v.connection_arn}"].arn : null
        webhook_url        = v.webhook_enabled ? aws_codepipeline_webhook.this_pipe_webhook["${k}_${v.source_repository_id}_${v.connection_arn}"].url : null
        webhook_secret     = module.webhook_secret.data[k]
      }
    )
  }
}
