locals {
  create_policy_map = {
    for k, v in var.log_map : k => v.create_policy == null ? var.log_create_policy_default : v.create_policy
  }
  log_map = {
    for k, v in var.log_map : k => merge(v, {
      create_policy      = local.create_policy_map[k]
      log_retention_days = v.log_retention_days == null ? var.log_retention_days_default : v.log_retention_days
      name_prefix        = local.name_prefix_map[k]
      policy_name        = local.create_policy_map[k] ? v.policy_name == null ? var.log_policy_name_default == null ? "${local.name_map[k]}-log" : var.log_policy_name_default : v.policy_name : null
      policy_name_infix  = v.policy_name_infix == null ? var.log_policy_name_infix_default : v.policy_name_infix
      policy_name_prefix = v.policy_name_prefix == null ? var.log_policy_name_prefix_default : v.policy_name_prefix
      resource_name      = local.resource_name_map[k]
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k]
        }
      )
    })
  }
  output_data = {
    for k, v in local.log_map : k => merge(v, module.this_policy[k].data, {
      log_group_arn  = aws_cloudwatch_log_group.this_log_group[k].arn
      log_group_name = aws_cloudwatch_log_group.this_log_group[k].name
    })
  }
  name_map = {
    for k, v in var.log_map : k => replace(k, "/[_]/", "-")
  }
  name_prefix_map = {
    for k, v in var.log_map : k => v.name_prefix == null ? var.log_name_prefix_default : v.name_prefix
  }
  resource_name_map = {
    for k, v in var.log_map : k => "${local.name_prefix_map[k]}${var.std_map.resource_name_prefix}${local.name_map[k]}${var.std_map.resource_name_suffix}"
  }
}
