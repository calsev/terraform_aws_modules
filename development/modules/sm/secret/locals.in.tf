{{ name.map() }}

module "init_map" {
  source                          = "../../secret/init_map"
  secret_map                      = local.l0_map
  secret_random_init_key_default  = var.secret_random_init_key_default
  secret_random_init_map_default  = var.secret_random_init_map_default
  secret_random_init_type_default = var.secret_random_init_type_default
  secret_random_init_value_map    = var.secret_random_init_value_map
}

locals {
  create_init_value_map = {
    for k, v in local.lx_map : k => v if v.secret_random_init
  }
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      sm_secret_name = aws_secretsmanager_secret.this_secret[k].name
    })
  }
  l0_map = {
    for k, v in var.secret_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.init_map.data[k], {
      force_overwrite      = v.force_overwrite == null ? var.secret_force_overwrite_default : v.force_overwrite
      kms_key_id           = v.kms_key_id == null ? var.secret_kms_key_id_default : v.kms_key_id
      resource_policy_doc  = jsondecode(v.resource_policy_json == null ? var.secret_resource_policy_json_default : v.resource_policy_json)
      recovery_window_days = v.recovery_window_days == null ? var.secret_recovery_window_days_default : v.recovery_window_days
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_secret, v_secret in v : k_secret => v_secret if !contains(["resource_policy_json"], k_secret)
      },
      module.this_policy.data[k], # This is just the iam maps
      {
        secret_init_value = v.secret_random_init ? module.initial_value.data[k] : null
        secret_arn        = aws_secretsmanager_secret.this_secret[k].arn
        secret_id         = aws_secretsmanager_secret.this_secret[k].id
      },
    )
  }
}
