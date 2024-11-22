locals {
  aws_region_name = "us-west-2"
  env_list        = toset(["com"])
  output_data_map = {
    for env in local.env_list : env => merge(
      {
        batch_compute = module.batch_compute[env].data
      },
      {
        com = {
          ecr_account_settings = module.ecr_account_settings.data
          ecr_repo_dns_alias   = module.dns_alias.data
          ecs_account_settings = module.ecs_account_settings.data
          latest_ami_map       = module.latest_ami_map.data
          repo_map             = module.repo.data
        }
        dev = {}
        prd = {}
      }[env]
    )
  }
  std_var_map = {
    for env in local.env_list : env => {
      app             = "inf-ecs"
      aws_region_name = local.aws_region_name
      env             = env
    }
  }
}
