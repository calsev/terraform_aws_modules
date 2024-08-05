locals {
  arn_list_index = flatten([
    for table, table_data in var.name_map_table : [
      for index in sort(distinct(table_data.name_list_index)) : startswith(index, "arn:") ? index : "${startswith(table, "arn:") ? table : "arn:${var.std_map.iam_partition}:dynamodb:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:table/${table}"}/index/${index}"
    ]
  ])
  arn_list_table = [
    for table, _ in var.name_map_table : startswith(table, "arn:") ? table : "arn:${var.std_map.iam_partition}:dynamodb:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:table/${table}"
  ]
}
