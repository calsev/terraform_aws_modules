locals {
  output_data = module.this_policy.data[var.name]
  lx_map = {
    (var.name) = {
      iam_policy_json                 = data.aws_iam_policy_document.network_policy.json
      name_append_default             = var.name_append_default
      name_include_app_fields_default = var.name_include_app_fields_default
      name_infix_default              = var.name_infix_default
      name_prefix_default             = var.name_prefix_default
      name_prepend_default            = var.name_prepend_default
      name_suffix_default             = var.name_suffix_default
    }
  }
}
