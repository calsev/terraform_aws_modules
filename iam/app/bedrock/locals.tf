locals {
  output_data = {
    bedrock_invoke_agent = module.agent_invoke_policy.data["bedrock_agent"]
    bedrock_invoke_model = module.model_invoke_policy.data["bedrock_model"]
  }
}
