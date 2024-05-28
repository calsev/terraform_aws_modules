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
        for _, v_act in v_stage.action_map : v_act.configuration_build_project_name if v_act.category == "Build"
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
  deploy_group_to_app_map = {
    for k, v_site in local.lx_map : k => merge([
      for v_stage in concat(v_site.build_stage_list, v_site.deploy_stage_list) : merge([
        for _, v_act in v_stage.action_map : {
          (v_act.configuration_deploy_group_name) = (v_act.configuration_deploy_application_name)
        } if v_act.category == "Deploy"
      ]...)
    ]...)
  }
  l0_map = {
    for k, v in var.pipe_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      build_data_key  = v.build_data_key == null ? var.pipe_build_data_key_default == null ? k : var.pipe_build_data_key_default : v.build_data_key
      deploy_data_key = v.deploy_data_key == null ? k : v.deploy_data_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      build_stage_list = [
        for v_build in v.build_stage_list : merge(v_build, {
          action_map = {
            for k_act, v_act in v_build.action_map : k_act => merge(v_act, {
              category                         = v_act.category == null ? var.pipe_stage_category_default : v_act.category
              configuration_build_project_name = v_act.configuration_build_project_key == null ? null : var.ci_cd_build_data_map[local.l1_map[k].build_data_key].build_map[v_act.configuration_build_project_key].name_effective
            })
          }
        })
      ]
      deploy_stage_list = [
        for v_build in v.deploy_stage_list : merge(v_build, {
          action_map = {
            for k_act, v_act in v_build.action_map : k_act => merge(v_act, {
              category                         = v_act.category == null ? var.pipe_stage_category_default : v_act.category
              configuration_build_project_name = v_act.configuration_build_project_key == null ? null : var.ci_cd_deploy_data_map[local.l1_map[k].deploy_data_key].build_map[v_act.configuration_build_project_key].name_effective
            })
          }
        })
      ]
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
