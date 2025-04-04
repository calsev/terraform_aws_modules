module "param_secret_temp" {
  # TODO: Manage secret instead
  source         = "path/to/modules/iam/policy/identity/secret"
  name           = "param_secret_temp"
  ssm_param_name = "github_com_example_access_token"
  std_map        = module.com_lib.std_map
}
