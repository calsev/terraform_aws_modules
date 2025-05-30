locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      bucket_arn_list = [for bucket_name in v.bucket_name_list : (startswith(bucket_name, "arn:") ? bucket_name : "arn:${var.std_map.iam_partition}:s3:::${bucket_name}")]
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      object_arn_list = [for bucket_arn in local.l1_map[k].bucket_arn_list : "${bucket_arn}/*"]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        bucket = local.l1_map[k].bucket_arn_list
        object = local.l2_map[k].object_arn_list
        star   = ["*"]
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
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
