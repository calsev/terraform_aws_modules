module "this_policy" {
  source      = "../../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    agent       = local.arn_list_agent
    agent-alias = local.arn_list_agent_alias
  }
  service_name = "bedrock"
  std_map      = var.std_map
}
