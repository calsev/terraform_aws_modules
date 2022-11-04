locals {
  pipe_map = {
    for k, v in var.pipe_map : k => merge(v, {
      iam_role_arn           = v.iam_role_arn == null ? var.pipe_iam_role_arn_default : v.iam_role_arn
      name                   = (v.name_infix == null ? var.pipe_name_infix_default : v.name_infix) ? local.resource_name_map[k] : replace(k, "/[_.]/", "-")
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
      tags = merge(var.std_map.tags, {
        Name = local.resource_name_map[k]
      })
    })
  }
  resource_name_map = {
    for k, v in var.pipe_map : k => "${var.std_map.resource_name_prefix}${replace(k, "/[_.]/", "-")}${var.std_map.resource_name_suffix}"
  }
}
