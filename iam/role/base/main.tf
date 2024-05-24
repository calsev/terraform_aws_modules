module "assume_role_policy" {
  source       = "../../../iam/policy/assume_role"
  for_each     = local.l1_map.enable_assume_role ? { this = {} } : {}
  service_list = local.l1_map.assume_role_service_list
}

resource "aws_iam_policy" "this_created_policy" {
  for_each = local.l1_map.role_policy_create_doc_map
  lifecycle {
    create_before_destroy = true
  }
  name   = module.name_map.data[each.key].name_effective
  policy = jsonencode(each.value)
  tags   = module.name_map.data[each.key].tags
}

resource "aws_iam_role" "this_iam_role" {
  assume_role_policy   = jsonencode(local.l2_map.assume_role_doc)
  max_session_duration = local.l1_map.max_session_duration_m == null ? null : local.l1_map.max_session_duration_m * 60
  dynamic "inline_policy" {
    for_each = local.l1_map.role_policy_inline_doc_map == null ? {} : local.l1_map.role_policy_inline_doc_map
    content {
      name   = inline_policy.key
      policy = jsonencode(inline_policy.value)
    }
  }
  dynamic "inline_policy" {
    # This ensures an empty policy
    for_each = local.l1_map.role_policy_inline_doc_map == null ? { this = {} } : length(local.l1_map.role_policy_inline_doc_map) == 0 ? { this = {} } : {}
    content {}
  }
  lifecycle {
    create_before_destroy = true
  }
  managed_policy_arns = [for _, arn in local.l4_map.role_policy_all_attached_arn_map : arn]
  name                = local.l1_map.name_effective
  path                = local.l1_map.role_path
  tags                = local.l1_map.tags
}

resource "aws_iam_instance_profile" "instance_profile" {
  for_each = local.l1_map.create_instance_profile ? { this = {} } : {}
  name     = local.l1_map.name_effective
  role     = aws_iam_role.this_iam_role.id
  tags     = local.l1_map.tags
}
