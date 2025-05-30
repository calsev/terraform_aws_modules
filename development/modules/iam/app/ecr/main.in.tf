data "aws_iam_policy_document" "ecr_get_token" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

module "iam_policy_ecr_get_token" {
  source              = "../../../iam/policy/identity/base"
  {{ name.map_item() }}
  policy_map = {
    ecr_get_token = {
      iam_policy_json = data.aws_iam_policy_document.ecr_get_token.json
    }
  }
  std_map = var.std_map
}
