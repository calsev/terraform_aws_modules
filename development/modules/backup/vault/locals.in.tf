{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.vault_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      changeable_for_days   = v.changeable_for_days == null ? var.vault_changeable_for_days_default : v.changeable_for_days
      force_destroy_enabled = v.force_destroy_enabled == null ? var.vault_force_destroy_enabled_default : v.force_destroy_enabled
      kms_key_key           = v.kms_key_key == null ? var.vault_kms_key_key_default : v.kms_key_key
      max_retention_days    = v.max_retention_days == null ? var.vault_max_retention_days_default : v.max_retention_days
      min_retention_days    = v.min_retention_days == null ? var.vault_min_retention_days_default : v.min_retention_days
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      kms_key_arn = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].key_arn
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        vault_arn = aws_backup_vault.this_vault[k].arn
        vault_id  = aws_backup_vault.this_vault[k].id
      }
    )
  }
}
