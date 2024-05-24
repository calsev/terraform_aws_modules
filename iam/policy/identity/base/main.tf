resource "aws_iam_policy" "policy" {
  for_each = var.name != null ? { this = {} } : {}
  lifecycle {
    create_before_destroy = true
  }
  name   = local.policy_name
  policy = var.iam_policy_json
  tags   = var.tag ? local.tags : null
}
