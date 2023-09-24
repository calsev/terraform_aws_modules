data "aws_iam_policy" "this_policy" {
  for_each = local.policy_arn_map
  arn      = each.value
}
