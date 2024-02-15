module "source_bucket_policy" {
  source = "path/to/modules/iam/policy/identity/s3/bucket"
  sid_map = {
    TriggerSource = {
      access           = "read"
      bucket_name_list = [module.s3.data[local.bucket_key].name_effective]
    }
  }
  std_map = module.com_lib.std_map
}

module "job_role" {
  source                   = "path/to/modules/iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  name                     = "job"
  policy_inline_json_map = {
    read_source_object = jsonencode(module.source_bucket_policy.data.iam_policy_doc)
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
