locals {
  output_data = {
    iam_policy_arn_ecr_get_token = module.iam_policy_ecr_get_token.data["ecr_get_token"].iam_policy_arn
    iam_policy_doc_ecr_get_token = module.iam_policy_ecr_get_token.data["ecr_get_token"].iam_policy_doc
  }
}
