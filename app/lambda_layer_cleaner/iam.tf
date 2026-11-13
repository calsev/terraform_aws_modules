data "aws_iam_policy_document" "cleaner_policy" {
  statement {
    actions = [
      "lambda:ListFunctions",
      "lambda:ListLayerVersions",
      "lambda:ListLayers",
    ]
    resources = ["*"]
    sid       = "LambdaList"
  }
  statement {
    actions = [
      "lambda:DeleteLayerVersion",
      "lambda:GetLayerVersionPolicy",
    ]
    resources = [
      "arn:${var.std_map.iam_partition}:lambda:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:layer:*",
    ]
    sid = "LambdaLayerVersionClean"
  }
}

module "cleaner_policy" {
  source = "../../iam/policy/identity/base"
  policy_map = {
    (local.policy_key) = {
      iam_policy_json = data.aws_iam_policy_document.cleaner_policy.json
    }
  }
  std_map = var.std_map
}
