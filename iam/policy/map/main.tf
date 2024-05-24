resource "aws_iam_policy" "this_created_policy" {
  for_each = local.policy_create_flattened_map
  lifecycle {
    create_before_destroy = true
  }
  name   = each.value.name_effective
  policy = jsonencode(each.value.iam_policy_doc)
  tags   = each.value.tags
}
