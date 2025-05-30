locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      report_group_key_list = v.build_project_name_list == null ? ["*"] : [for key in v.build_project_name_list : "${key}-*"]
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        report = [
          for key in local.l1_map[k].report_group_key_list :
          "arn:${var.std_map.iam_partition}:codebuild:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:report-group/${key}"
        ]
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
