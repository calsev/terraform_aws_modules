module "param_secret_temp" {
  # TODO: Manage secret instead
  source = "path/to/modules/iam/policy/identity/secret"
  policy_map = {
    secret_temp = {
      sm_secret_name_list = [
        "github_com_example_access_token",
      ]
    }
  }
  std_map = module.com_lib.std_map
}
