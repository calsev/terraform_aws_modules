locals {
  aws_region_name = "us-west-2"
  db_key          = "main"
  env_list_db     = toset(["prd"])
  env_list        = ["com", "dev", "prd"]
  output_data_map = merge(
    {
      com = {
        user_pool = module.user_pool.data
      }
      dev = {}
      prd = {}
    },
    {
      for env in local.env_list_db : env => {
        db            = module.db[env].data
        db_proxy      = module.db_proxy[env].data
        db_proxy_role = module.db_proxy_role[env].data
        db_subnet     = module.db_sub[env].data
      }
    },
  )
  std_var_map = {
    for env in local.env_list : env => {
      app             = "data-core"
      aws_region_name = local.aws_region_name
      env             = env
    }
  }
}
