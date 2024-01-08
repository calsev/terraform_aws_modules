module "this_policy" {
  source       = "../../../../iam/policy/resource/access_resource"
  service_name = local.service_name
  sid_map      = local.sid_map
  std_map      = var.std_map
}

resource "aws_cloudwatch_log_resource_policy" "this_resource_policy" {
  policy_document = jsonencode(module.this_policy.iam_policy_doc)
  policy_name     = var.policy_name
}
