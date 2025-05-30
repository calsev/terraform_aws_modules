data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.lx_map
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = each.value.iam_role_arn_list
  }
}

{{ iam.policy_identity_base(map="create_policy_map") }}
