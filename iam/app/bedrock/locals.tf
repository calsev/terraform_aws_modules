locals {
  output_data = {
    iam_policy_arn_map_bedrock_invoke_agent = module.agent_invoke_policy.data.iam_policy_arn_map
    iam_policy_arn_map_bedrock_invoke_model = module.model_invoke_policy.data.iam_policy_arn_map
    iam_policy_doc_map_bedrock_invoke_agent = module.agent_invoke_policy.data.iam_policy_doc_map
    iam_policy_doc_map_bedrock_invoke_model = module.model_invoke_policy.data.iam_policy_doc_map
  }
}
