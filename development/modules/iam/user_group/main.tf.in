resource "aws_iam_group" "this_group" {
  for_each = local.group_map
  name     = each.value.name_effective
  path     = each.value.path
}

resource "aws_iam_user" "this_user" {
  for_each             = local.user_map
  force_destroy        = each.value.force_destroy
  name                 = each.value.name_effective
  path                 = each.value.path
  permissions_boundary = null # TODO
  tags                 = each.value.tags
}

resource "aws_iam_access_key" "this_access_key" {
  for_each = local.user_key_map
  pgp_key  = each.value.pgp_key
  status   = "Active"
  user     = aws_iam_user.this_user[each.key].name
}

resource "aws_iam_user_login_profile" "this_login" {
  for_each = local.user_console_map
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
  pgp_key                 = each.value.pgp_key
  password_reset_required = true
  user                    = aws_iam_user.this_user[each.key].name
}

resource "aws_iam_group_membership" "this_membership" {
  for_each = local.group_map
  group    = aws_iam_group.this_group[each.key].name
  name     = each.value.name_effective
  users = [
    for k_user in each.value.k_user_list : aws_iam_user.this_user[k_user].name
  ]
}

resource "aws_iam_group_policy" "this_group_policy" {
  for_each = module.group_policy_map.policy_inline_map_flattened
  group    = aws_iam_group.this_group[each.value.k].name
  name     = each.value.k_inline
  policy   = jsonencode(each.value.iam_policy_doc)
}

resource "aws_iam_group_policy_attachment" "this_group_attachment" {
  for_each   = module.group_policy_map.policy_attach_map_flattened
  group      = aws_iam_group.this_group[each.value.k].name
  policy_arn = each.value.iam_policy_arn
}

resource "aws_iam_user_policy" "this_user_policy" {
  for_each = module.user_policy_map.policy_inline_map_flattened
  name     = each.value.k_inline
  policy   = jsonencode(each.value.iam_policy_doc)
  user     = aws_iam_user.this_user[each.value.k].name
}

resource "aws_iam_user_policy_attachment" "this_user_attachment" {
  for_each   = module.user_policy_map.policy_attach_map_flattened
  policy_arn = each.value.iam_policy_arn
  user       = aws_iam_user.this_user[each.value.k].name
}
