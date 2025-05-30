resource "aws_iam_policy" "policy" {
  for_each = local.create_policy_map
  lifecycle {
    create_before_destroy = true
  }
  name   = each.value.name_effective
  policy = each.value.iam_policy_json
  tags   = each.value.tags
}
