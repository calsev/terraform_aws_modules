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
  source                          = "../../../../iam/policy/identity/base"
  # Appended here
  {{ name.map_item(append="") }}
  {{ iam.policy_map_item_base(append="") }}
  std_map                         = var.std_map
}
