locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      adapter_arn = v.adapter_name == null ? null : startswith(v.adapter_name, "arn:") ? v.adapter_name : "arn:${var.std_map.iam_partition}:textract:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:/adapters/${v.adapter_name}"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        adapter        = local.l1_map[k].adapter_arn == null ? [] : [local.l1_map[k].adapter_arn]
        adapterversion = local.l1_map[k].adapter_arn == null ? [] : ["${local.l1_map[k].adapter_arn}/versions/*"]
        star           = ["*"]
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
