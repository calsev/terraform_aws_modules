data "aws_iam_policy_document" "this_policy_doc" {
  statement {
    actions   = var.std_map.service_resource_access_action.codebuild.report_group.write
    resources = ["arn:${var.std_map.iam_partition}:codebuild:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:report-group/${local.report_group_key}"]
    sid       = "Report${var.std_map.access_title_map.write}"
  }
}

module "this_policy" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.this_policy_doc.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
