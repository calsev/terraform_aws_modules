locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      resource_connection_map = {
        connection = v.connection_arn != null ? [v.connection_arn] : ["arn:${var.std_map.iam_partition}:codestar-connections:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:connection/*"]
        star       = ["*"]
      }
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = v.connection_host_arn == null || v.connection_host_arn == "" ? tomap(local.l1_map[k].resource_connection_map) : tomap(merge(local.l1_map[k].resource_connection_map, {
        host = [v.connection_host_arn]
      }))
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
