module "name_map" {
  source   = "../name_map"
  name_map = var.secret_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.secret_map : k => merge(v, module.name_map.data[k], {
      create_policy        = v.create_policy == null ? var.secret_create_policy_default : v.create_policy
      force_overwrite      = v.force_overwrite == null ? var.secret_force_overwrite_default : v.force_overwrite
      kms_key_id           = v.kms_key_id == null ? var.secret_kms_key_id_default : v.kms_key_id
      policy_access_list   = v.policy_access_list == null ? var.secret_policy_access_list_default : v.policy_access_list
      policy_name_infix    = v.policy_name_infix == null ? var.secret_policy_name_infix_default : v.policy_name_infix
      policy_name_prefix   = v.policy_name_prefix == null ? var.secret_policy_name_prefix_default : v.policy_name_prefix
      resource_policy_doc  = jsondecode(v.resource_policy_json == null ? var.secret_resource_policy_json_default : v.resource_policy_json)
      recovery_window_days = v.recovery_window_days == null ? var.secret_recovery_window_days_default : v.recovery_window_days
    })
  }
  l2_map = {
    for k, _ in var.secret_map : k => {
      policy_name = local.l1_map[k].create_policy ? local.l1_map[k].policy_name == null ? "${local.l1_map[k].name_simple}-secret" : local.l1_map[k].policy_name : null # This controls policy creation
    }
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
    for k, v in var.secret_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
