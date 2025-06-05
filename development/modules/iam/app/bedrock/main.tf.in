module "agent_invoke_policy" {
  source = "../../../iam/policy/identity/bedrock/agent_alias"
  policy_map = {
    bedrock_agent = {
      name_list_agent = ["*"]
      name_map_agent_alias = {
        "*" = ["*"]
      }
    }
  }
  {{ name.map_item() }}
  std_map             = var.std_map
}

module "model_invoke_policy" {
  source = "../../../iam/policy/identity/bedrock/model_job"
  policy_map = {
    bedrock_model = {
      name_list_application_inference_profile = ["*"]
      name_list_inference_profile             = ["*"]
      name_list_model_foundation              = ["*"]
    }
  }
  {{ name.map_item() }}
  std_map             = var.std_map
}
