data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.sid_map
  dynamic "statement" {
    for_each = each.value
    content {
      actions   = var.std_map.service_resource_access_action[var.service_name][statement.key][each.key]
      resources = statement.value.resource_list
      sid       = statement.value.sid
    }
  }
}

module "this_policy" {
  for_each        = var.name == null ? {} : local.sid_map
  source          = "../iam_policy_role"
  iam_policy_json = data.aws_iam_policy_document.this_policy_doc[each.key].json
  name            = "${var.name}-${each.key}"
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
  tag             = var.tag
}
