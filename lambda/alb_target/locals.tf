module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_lambda_permission_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_prepend = v.lambda_permission_name_prepend
      source_arn   = module.target_group.data[k].target_group_arn
    })
  }
  l0_map = {
    for k, v in var.target_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      action_map = {
        forward_to_service = {
          action_order = v.action_order
          action_type  = "forward"
        }
      }
      lambda_arn = var.lambda_data_map[v.lambda_key].lambda_arn
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        elb_listener      = module.listener.data[k]
        elb_target        = module.target_group.data[k]
        lambda_permission = module.lambda_permission.data[k]
      }
    )
  }
}
