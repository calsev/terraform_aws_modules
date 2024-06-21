resource "aws_ecs_account_setting_default" "this_setting" {
  for_each = local.setting_map
  name     = each.key
  value    = each.value
}

resource "aws_ebs_encryption_by_default" "this_default_encryption" {
  enabled = var.ebs_encryption_by_default_enabled
}
