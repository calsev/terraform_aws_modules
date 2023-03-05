module "assume_role_policy" {
  source       = "../iam_policy_assume_role"
  for_each     = var.assume_role_service_list != null ? { this = {} } : {}
  service_list = var.assume_role_service_list
}

resource "aws_iam_policy" "this_created_policy" {
  for_each = var.create_policy_json_map
  name     = local.policy_name_map[each.key]
  policy   = each.value
  tags = merge(
    var.std_map.tags,
    {
      Name = local.policy_name_map[each.key]
    }
  )
}

resource "aws_iam_role" "this_iam_role" {
  assume_role_policy   = local.assume_role_json
  max_session_duration = var.max_session_duration
  dynamic "inline_policy" {
    for_each = local.inline_policy_json_map
    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
  dynamic "inline_policy" {
    for_each = length(local.inline_policy_json_map) == 0 ? { this = {} } : {}
    content {}
  }
  managed_policy_arns = [for _, arn in local.all_attached_policy_arn_map : arn]
  name                = local.role_name
  path                = local.role_path
  tags                = var.tag ? local.tags : null
}

resource "aws_iam_instance_profile" "instance_profile" {
  for_each = var.create_instance_profile ? { this = {} } : {}
  name     = local.role_name
  role     = aws_iam_role.this_iam_role.id
  tags     = local.tags
}
