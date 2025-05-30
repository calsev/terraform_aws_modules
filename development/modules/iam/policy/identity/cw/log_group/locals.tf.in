locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      log_group_arn = startswith(v.log_group_name, "arn:") ? v.log_group_name : "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:log-group:${v.log_group_name}"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        group  = ["${local.l1_map[k].log_group_arn}:*"]
        stream = ["${local.l1_map[k].log_group_arn}:log-stream:*"]
        star   = ["*"]
      }
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
      }
    )
  }
}
