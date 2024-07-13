module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_permission_map = {
    for k, v in local.lx_map : k => v if v.lambda_arn != null
  }
  l0_map = {
    for k, v in var.permission_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      action     = v.action == null ? var.permission_action_default : v.action
      name       = v.lambda_arn == null ? null : split(":", v.lambda_arn)[length(split(":", v.lambda_arn)) - 1]
      principal  = v.principal == null ? var.permission_principal_default : v.principal
      qualifier  = v.qualifier == null ? var.permission_qualifier_default : v.qualifier
      source_arn = v.source_arn == null ? var.permission_source_arn_default : v.source_arn
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      function_url_auth_type = local.l1_map[k].action == "lambda:InvokeFunctionUrl" ? "AWS_IAM" : null # This cannot be NONE
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
      }
    )
  }
}
