module "analyze_policy" {
  source = "../../../iam/policy/identity/textract"
  policy_map = {
    textract_analyze = {
      adapter_name = "*"
    }
  }
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}
