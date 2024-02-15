module "name_map" {
  source   = "../../name_map"
  name_map = var.secret_map
  std_map  = var.std_map
}

module "policy_map" {
  source                      = "../../iam/policy_name_map"
  name_map                    = var.secret_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  l1_map = {
    for k, v in var.secret_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], {
      force_overwrite      = v.force_overwrite == null ? var.secret_force_overwrite_default : v.force_overwrite
      kms_key_id           = v.kms_key_id == null ? var.secret_kms_key_id_default : v.kms_key_id
      resource_policy_doc  = jsondecode(v.resource_policy_json == null ? var.secret_resource_policy_json_default : v.resource_policy_json)
      recovery_window_days = v.recovery_window_days == null ? var.secret_recovery_window_days_default : v.recovery_window_days
    })
  }
  output_data = {
    for k, v in var.secret_map : k => merge(
      {
        for k_secret, v_secret in local.secret_map[k] : k_secret => v_secret if !contains(["resource_policy_json"], k_secret)
      },
      module.this_policy[k].data,
      {
        secret_arn = aws_secretsmanager_secret.this_secret[k].arn
      },
    )
  }
  secret_map = {
    for k, v in var.secret_map : k => merge(local.l1_map[k])
  }
}
