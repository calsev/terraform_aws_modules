data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.create_doc_x_map
  dynamic "statement" {
    for_each = each.value.sid_map[each.value.k_access].resource_map
    content {
      actions   = var.std_map.service_resource_access_action[each.value.service_name][statement.key][each.value.k_access]
      resources = statement.value.resource_list
      sid       = statement.value.sid
    }
  }
}

module "this_policy" {
  source = "../../../../iam/policy/identity/base"
  # Appended here
  name_append_default             = ""
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_map                      = local.create_policy_map
  policy_create_default           = var.policy_create_default
  policy_name_append_default      = ""
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
