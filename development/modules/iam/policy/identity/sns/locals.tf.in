locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      sns_topic_arn = startswith(v.sns_topic_name, "arn:") ? v.sns_topic_name : "arn:${var.std_map.iam_partition}:sns:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:${v.sns_topic_name}"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        topic = [local.l1_map[k].sns_topic_arn]
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
