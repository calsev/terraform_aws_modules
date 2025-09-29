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
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
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
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "knowledge_base_policy" {
  source = "../../../iam/policy/identity/bedrock/knowledge_base"
  policy_map = {
    bedrock_knowledge_base = {
      name_list_knowledge_base = ["*"]
    }
  }
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

