locals {
  project_arn_list = [
    for name in sort(distinct(var.build_project_name_list)) : "arn:${var.std_map.iam_partition}:codebuild:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:project/${name}"
  ]
}
