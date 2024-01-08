module "this_policy" {
  source      = "../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    report = ["arn:${var.std_map.iam_partition}:codebuild:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:report-group/${local.report_group_key}"]
  }
  service_name = "codebuild"
  std_map      = var.std_map
}
