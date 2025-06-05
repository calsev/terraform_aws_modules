resource "aws_cognito_user_group" "this_group" {
  for_each     = local.lx_map
  name         = each.value.name_effective
  user_pool_id = each.value.user_pool_id
  precedence   = each.value.precedence
  role_arn     = each.value.iam_role_arn
}
