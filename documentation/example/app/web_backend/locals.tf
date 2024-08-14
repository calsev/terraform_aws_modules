locals {
  aws_region_name = "us-west-2"
  env_list        = toset(["prd"])
  output_data = {
    for env in local.env_list : env => {
      app = module.ecs_app[env].data
    }
  }
  std_var_map = {
    for env in local.env_list : env => {
      app             = "app-back"
      aws_region_name = local.aws_region_name
      env             = env
    }
  }
}
