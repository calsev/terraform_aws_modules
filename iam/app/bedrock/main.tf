module "agent_invoke_policy" {
  source          = "../../../iam/policy/identity/bedrock/agent_alias"
  name            = "bedrock_agent"
  name_list_agent = ["*"]
  name_map_agent_alias = {
    "*" = ["*"]
  }
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

module "model_invoke_policy" {
  source                     = "../../../iam/policy/identity/bedrock/model_job"
  name                       = "bedrock_model"
  name_list_model_foundation = ["*"]
  name_prefix                = var.name_prefix
  std_map                    = var.std_map
}
