module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  build_name_list_map = {
    for k, v_site in local.lx_map : k => flatten([
      for v_stage in concat(v_site.build_stage_list, v_site.deploy_stage_list) : [
        for _, v_action in v_stage.action_map : v_action.configuration_project_name
      ]
    ])
  }
  create_pipe_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_role_arn    = module.code_pipe_role[k].data.iam_role_arn
      secret_is_param = v.ci_cd_pipeline_webhook_secret_is_param
      stage_list = concat(
        v.build_stage_list,
        v.deploy_stage_list,
      )
    })
  }
  l0_map = {
    for k, v in var.pipe_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
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
        code_pipe = module.code_pipe.data[k]
        role = {
          code_pipe = module.code_pipe_role[k].data
        }
      }
    )
  }
}
