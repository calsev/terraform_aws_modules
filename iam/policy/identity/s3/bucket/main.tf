data "aws_iam_policy_document" "this_policy_doc" {
  # Resource-access paradigm does not work for multiple-sub-path-based access
  dynamic "statement" {
    for_each = local.sid_map
    content {
      actions   = var.std_map.service_resource_access_action.s3[statement.value.resource_type][statement.value.access]
      resources = statement.value.resource_list
      sid       = statement.value.sid
    }
  }
  dynamic "statement" {
    for_each = local.star_sid_map
    content {
      actions   = statement.value.action_list
      resources = ["*"]
      sid       = statement.value.sid
    }
  }
}

module "this_policy" {
  source          = "../../../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.this_policy_doc.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
