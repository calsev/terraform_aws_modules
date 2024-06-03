module "job_role" {
  source                   = "path/to/modules/iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  name                     = "job"
  role_policy_attach_arn_map_default = {
    read_source_object = module.s3.data[local.bucket_key].policy.iam_policy_arn_map["read"]
  }
  std_map = module.com_lib.std_map
}

module "param_secret_temp" {
  # TODO: Manage secret instead
  source         = "path/to/modules/iam/policy/identity/secret"
  name           = "param_secret_temp"
  ssm_param_name = "github_com_example_access_token"
  std_map        = module.com_lib.std_map
}
