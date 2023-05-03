module "name_map" {
  source              = "../name_map"
  name_map            = var.log_map
  name_prefix_default = var.log_name_prefix_default
  std_map             = var.std_map
}

locals {
  l1_map = {
    for k, v in var.log_map : k => merge(v, module.name_map.data[k], {
      allow_public_read  = v.allow_public_read == null ? var.log_allow_public_read_default : v.allow_public_read
      create_policy      = v.create_policy == null ? var.log_create_policy_default : v.create_policy
      log_retention_days = v.log_retention_days == null ? var.log_retention_days_default : v.log_retention_days
      policy_name_infix  = v.policy_name_infix == null ? var.log_policy_name_infix_default : v.policy_name_infix
      policy_name_prefix = v.policy_name_prefix == null ? var.log_policy_name_prefix_default : v.policy_name_prefix
    })
  }
  l2_map = {
    for k, _ in var.log_map : k => {
      policy_access_list = local.l1_map[k].allow_public_read ? ["public_read", "read", "write"] : ["read", "write"]
      policy_name        = local.l1_map[k].create_policy ? local.l1_map[k].policy_name == null ? "${local.l1_map[k].name_simple}-log" : local.l1_map[k].policy_name : null # This controls policy creation
    }
  }
  log_map = {
    for k, _ in var.log_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.log_map : k => merge(
      v,
      module.this_policy[k].data,
      {
        log_group_arn  = aws_cloudwatch_log_group.this_log_group[k].arn
        log_group_name = aws_cloudwatch_log_group.this_log_group[k].name
      },
    )
  }
}
