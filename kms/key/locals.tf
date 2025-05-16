module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      key_arn_list = [aws_kms_key.this_key[k].arn]
    })
  }
  l0_map = {
    for k, v in var.key_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      allow_cloudtrail                           = v.allow_cloudtrail == null ? var.allow_cloudtrail_default : v.allow_cloudtrail
      allow_iam_delegation                       = v.allow_iam_delegation == null ? var.allow_iam_delegation_default : v.allow_iam_delegation
      custom_key_store_id                        = v.custom_key_store_id == null ? var.key_custom_key_store_id_default : v.custom_key_store_id
      customer_master_key_spec                   = v.customer_master_key_spec == null ? var.key_customer_master_key_spec_default : v.customer_master_key_spec
      deletion_window_days                       = v.deletion_window_days == null ? var.key_deletion_window_days_default : v.deletion_window_days
      iam_policy_json                            = v.iam_policy_json == null ? var.key_iam_policy_json_default : v.iam_policy_json
      is_enabled                                 = v.is_enabled == null ? var.key_is_enabled_default : v.is_enabled
      key_usage                                  = v.key_usage == null ? var.key_key_usage_default : v.key_usage
      multi_region_enabled                       = v.multi_region_enabled == null ? var.key_multi_region_enabled_default : v.multi_region_enabled
      policy_lockout_safety_check_bypass_enabled = v.policy_lockout_safety_check_bypass_enabled == null ? var.key_policy_lockout_safety_check_bypass_enabled_default : v.policy_lockout_safety_check_bypass_enabled
      rotation_period_days                       = v.rotation_period_days == null ? var.key_rotation_period_days_default : v.rotation_period_days
      xks_key_id                                 = v.xks_key_id == null ? var.key_xks_key_id_default : v.xks_key_id
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      iam_policy_doc       = local.l1_map[k].iam_policy_json == null ? null : jsondecode(local.l1_map[k].iam_policy_json)
      key_rotation_enabled = local.l1_map[k].rotation_period_days != 0
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["iam_policy_json"], k_attr)
      },
      module.key_policy.data[k],
      {
        alias_arn      = aws_kms_alias.this_alias[k].arn
        key_arn        = aws_kms_key.this_key[k].arn
        key_id         = aws_kms_key.this_key[k].key_id
        key_policy_doc = module.key_resource_policy[k].iam_policy_doc
      }
    )
  }
}
