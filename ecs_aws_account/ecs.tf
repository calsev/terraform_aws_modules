resource "aws_ecs_account_setting_default" "this_setting" {
  for_each = local.setting_map
  name     = each.key
  value    = each.value
}
