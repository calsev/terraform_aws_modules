resource "aws_backup_vault" "this_vault" {
  for_each      = local.lx_map
  force_destroy = each.value.force_destroy_enabled
  kms_key_arn   = each.value.kms_key_arn
  name          = each.value.name_effective
  tags          = each.value.tags
}

resource "aws_backup_vault_lock_configuration" "this_lock" {
  for_each            = local.lx_map
  backup_vault_name   = aws_backup_vault.this_vault[each.key].name
  changeable_for_days = each.value.changeable_for_days
  max_retention_days  = each.value.max_retention_days
  min_retention_days  = each.value.min_retention_days
}
