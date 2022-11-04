data "aws_iam_policy_document" "assume_role_policy" {
  for_each = local.assume_role_policy_map
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [for service in each.value : "${service}.amazonaws.com"]
      type        = "Service"
    }
    sid = "AssumeThisRole"
  }
}
