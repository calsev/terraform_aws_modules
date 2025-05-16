module "mobile_analytics_policy" {
  source                          = "../../../iam/policy/identity/mobile_analytics"
  name                            = "mobile_analytics"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "mobile_analytics_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["pinpoint"]
  role_policy_attach_arn_map_default = {
    batch_service = module.mobile_analytics_policy.data.iam_policy_arn_map["write"]
  }
  name                            = "mobile_analytics"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}
