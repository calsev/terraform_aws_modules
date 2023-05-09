locals {
  output_data = {
    iam_policy_arn_ecr_get_token = module.iam_policy_ecr_get_token.iam_policy_arn
    iam_policy_doc_ecr_get_token = jsondecode(data.aws_iam_policy_document.ecr_get_token.json)
  }
}
