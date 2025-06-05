locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      efs_arn = startswith(v.efs_arn, "arn:") ? v.efs_arn : "arn:${var.std_map.iam_partition}:elasticfilesystem:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:file-system/${v.efs_arn}"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        file-system = [local.l1_map[k].efs_arn]
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
