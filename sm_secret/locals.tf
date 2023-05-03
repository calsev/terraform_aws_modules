module "name_map" {
  source   = "../name_map"
  name_map = var.secret_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.secret_map : k => merge(v, module.name_map.data[k], {
      force_overwrite      = v.force_overwrite == null ? var.secret_force_overwrite_default : v.force_overwrite
      kms_key_id           = v.kms_key_id == null ? var.secret_kms_key_id_default : v.kms_key_id
      policy_doc           = jsondecode(v.policy_json == null ? var.secret_policy_json_default : v.policy_json)
      recovery_window_days = v.recovery_window_days == null ? var.secret_recovery_window_days_default : v.recovery_window_days
    })
  }
  output_data = {
    for k, v in var.secret_map : k => merge(
      {
        for k_secret, v_secret in local.secret_map[k] : k_secret => v_secret if !contains(["policy_json"], k_secret)
      },
      {
        secret_arn = aws_secretsmanager_secret.this_secret[k].arn
      },
    )
  }
  secret_map = {
    for k, v in var.secret_map : k => merge(local.l1_map[k])
  }
}
