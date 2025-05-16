locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      repo_arn = "arn:${var.std_map.iam_partition}:ecr:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:repository/${v.repo_name}"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        repo = [local.l1_map[k].repo_arn]
        star = ["*"]
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
