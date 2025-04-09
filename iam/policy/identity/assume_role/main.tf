data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = var.iam_role_arn_list
  }
}

module "policy" {
  source          = "../../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.assume_role.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
