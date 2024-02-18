module "name_map" {
  source             = "../../name_map"
  name_infix_default = var.pipe_name_infix_default
  name_map           = local.l0_map
  std_map            = var.std_map
}

locals {
  l0_map = {
    for k, v in var.pipe_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      iam_role_arn           = v.iam_role_arn == null ? var.pipe_iam_role_arn_default : v.iam_role_arn
      pipeline_type          = v.pipeline_type == null ? var.pipe_pipeline_type_default : v.pipeline_type
      source_branch          = v.source_branch == null ? var.pipe_source_branch_default : v.source_branch
      source_connection_name = v.source_connection_name == null ? var.pipe_source_connection_name_default : v.source_connection_name
      source_detect_changes  = v.source_detect_changes == null ? var.pipe_source_detect_changes_default : v.source_detect_changes
      source_repository_id   = v.source_repository_id == null ? var.pipe_source_repository_id_default : v.source_repository_id
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
      variable_map       = v.variable_map == null ? var.pipe_variable_map_default : v.variable_map
      webhook_event_list = v.webhook_event_list == null ? var.pipe_webhook_event_list_default : v.webhook_event_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
        code_pipe_arn  = aws_codepipeline.this_pipeline[k].arn
        webhook_secret = module.webhook_secret.data[k],
      }
    )
  }
}
