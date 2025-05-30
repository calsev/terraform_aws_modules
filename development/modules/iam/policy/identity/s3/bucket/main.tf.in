data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.lx_map
  # Resource-access paradigm does not work for multiple-sub-path-based access
  dynamic "statement" {
    for_each = each.value.sid_map
    content {
      actions   = var.std_map.service_resource_access_action.s3[statement.value.resource_type][statement.value.access]
      resources = statement.value.resource_list
      sid       = statement.value.sid
    }
  }
  dynamic "statement" {
    for_each = each.value.star_sid_map
    content {
      actions   = statement.value.action_list
      resources = ["*"]
      sid       = statement.value.sid
    }
  }
}

{{ iam.policy_identity_base(map="create_policy_map") }}
