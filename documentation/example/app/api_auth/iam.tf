module "api_role" {
  source   = "path/to/modules/iam/role/api_gateway"
  for_each = local.env_list
  name = {
    dev = "api_dev.example.com_api"
    prd = "api.example.com_api"
  }[each.key]
  role_policy_attach_arn_map_default = {
    auth_invoke        = module.lambda[each.key].data[local.lambda_name_auth].iam_policy_map["write"].iam_policy_arn
    integration_invoke = module.lambda[each.key].data[local.lambda_name_integration].iam_policy_map["write"].iam_policy_arn
    options_invoke     = module.lambda[each.key].data[local.lambda_name_options].iam_policy_map["write"].iam_policy_arn
  }
  std_map = module.com_lib[each.key].std_map
}
