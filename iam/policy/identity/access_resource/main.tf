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

resource "aws_iam_policy" "policy" {
  for_each = local.create_policy_map
  lifecycle {
    create_before_destroy = true
  }
  name   = each.value.name_effective
  policy = each.value.iam_policy_json
  tags   = each.value.tags
}
