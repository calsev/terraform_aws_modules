data "aws_iam_policy_document" "ecr_get_token" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

module "iam_policy_ecr_get_token" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.ecr_get_token.json
  name            = "ecr_get_token"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
