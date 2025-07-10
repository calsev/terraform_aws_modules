# L1

module "assume_role_policy" {
  source       = "../../../iam/policy/assume_role"
  for_each     = local.l1_map.enable_assume_role ? { this = {} } : {}
  account_map  = local.l1_map.assume_role_account_map
  service_list = local.l1_map.assume_role_service_list
  std_map      = var.std_map
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

# L2

resource "aws_iam_role" "this_iam_role" {
  assume_role_policy   = jsonencode(local.l2_map.assume_role_doc)
  max_session_duration = local.l1_map.max_session_duration_m == null ? null : local.l1_map.max_session_duration_m * 60
  lifecycle {
    create_before_destroy = true
  }
  name = local.l1_map.name_effective
  path = local.l1_map.role_path
  tags = local.l1_map.tags
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = local.l1_map.role_policy_inline_doc_map
  name     = each.key
  policy   = jsonencode(each.value)
  role     = aws_iam_role.this_iam_role.id
}

resource "aws_iam_role_policies_exclusive" "inline_policies" {
  role_name = aws_iam_role.this_iam_role.name
  policy_names = length(local.l1_map.role_policy_inline_doc_map) == 0 ? [] : [
    for k, v in local.l1_map.role_policy_inline_doc_map : k
  ]
}

# L3

# L4

resource "aws_iam_role_policy_attachments_exclusive" "managed_policies" {
  role_name   = aws_iam_role.this_iam_role.name
  policy_arns = [for _, arn in local.l4_map.role_policy_all_attached_arn_map : arn]
}

resource "aws_iam_instance_profile" "instance_profile" {
  for_each = local.l1_map.create_instance_profile ? { this = {} } : {}
  lifecycle {
    create_before_destroy = true
  }
  name = local.l1_map.name_effective
  role = aws_iam_role.this_iam_role.id
  tags = local.l1_map.tags
}
