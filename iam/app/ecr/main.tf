data "aws_iam_policy_document" "ecr_get_token" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

module "iam_policy_ecr_get_token" {
  source                          = "../../../iam/policy/identity/base"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_map = {
    ecr_get_token = {
      iam_policy_json = data.aws_iam_policy_document.ecr_get_token.json
    }
  }
  std_map = var.std_map
}
