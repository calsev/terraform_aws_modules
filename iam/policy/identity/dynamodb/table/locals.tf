locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      arn_list_index = flatten([
        for table, table_data in v.name_map_table : [
          for index in sort(distinct(table_data.name_list_index)) : startswith(index, "arn:") ? index : "${startswith(table, "arn:") ? table : "arn:${var.std_map.iam_partition}:dynamodb:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:table/${table}"}/index/${index}"
        ]
      ])
      arn_list_table = [
        for table, _ in v.name_map_table : startswith(table, "arn:") ? table : "arn:${var.std_map.iam_partition}:dynamodb:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:table/${table}"
      ]
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        index = local.l1_map[k].arn_list_index
        star  = ["*"]
        table = local.l1_map[k].arn_list_table
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
