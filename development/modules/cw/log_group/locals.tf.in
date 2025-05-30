{{ name.map() }}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      log_group_name = aws_cloudwatch_log_group.this_log_group[k].name
      name_prefix    = null # There are /aws/ log groups
    })
  }
  l0_map = {
    for k, v in var.log_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      allow_public_read  = v.allow_public_read == null ? var.log_allow_public_read_default : v.allow_public_read
      kms_key_id         = v.kms_key_id == null ? var.log_kms_key_id_default : v.kms_key_id
      log_group_class    = v.log_group_class == null ? var.log_group_class_default : v.log_group_class
      log_retention_days = v.log_retention_days == null ? var.log_retention_days_default : v.log_retention_days
      skip_destroy       = v.skip_destroy == null ? var.log_skip_destroy_default : v.skip_destroy
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      policy_access_list = local.l1_map[k].allow_public_read ? ["public_read", "read", "write"] : ["read", "write"]
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
      module.this_policy.data[k],
      {
        log_group_arn  = aws_cloudwatch_log_group.this_log_group[k].arn
        log_group_name = aws_cloudwatch_log_group.this_log_group[k].name
      },
    )
  }
}
