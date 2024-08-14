locals {
  aws_region_name   = "us-west-2"
  db_key            = "main"
  env_list          = ["com", "dev", "prd"]
  env_list_instance = toset(["prd"])
  output_data_map = merge(
    {
      com = {}
      dev = {}
      prd = {}
    },
    {
      for env in local.env_list_instance : env => {
        db            = module.db[env].data
        db_proxy      = module.db_proxy[env].data
        db_proxy_role = module.db_proxy_role[env].data
        db_subnet     = module.db_sub[env].data
        identity_pool = module.identity_pool[env].data
        iam = {
          role = {
            identity_pool = module.app_user_role[env].data
          }
        }
        user_pool = module.user_pool[env].data
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
