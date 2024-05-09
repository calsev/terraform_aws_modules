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
          latest_ami_map = module.latest_ami_map.data
          setting        = module.account_settings.data
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
