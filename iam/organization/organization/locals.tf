module "name_map" {
  source                          = "../../../name_map"
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
  l0_map = {
    for k, v in var.organization_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      aws_service_access_principal_list = v.aws_service_access_principal_list == null ? var.organization_aws_service_access_principal_list_default : v.aws_service_access_principal_list
      enabled_policy_type_list          = v.enabled_policy_type_list == null ? var.organization_enabled_policy_type_list_default : v.enabled_policy_type_list
      feature_set                       = v.feature_set == null ? var.organization_feature_set_default : v.feature_set
      iam_feature_list                  = v.iam_feature_list == null ? var.organization_iam_feature_list_default : v.iam_feature_list
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
        organization_arn = aws_organizations_organization.org[k].arn
        organization_id  = aws_organizations_organization.org[k].id
      }
    )
  }
}
