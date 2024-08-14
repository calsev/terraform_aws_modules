module "db_proxy_role" {
  source                   = "path/to/modules/iam/role/base"
  for_each                 = local.env_list_instance
  assume_role_service_list = ["rds"]
  name                     = "proxy"
  role_policy_attach_arn_map_default = {
    db_secret_read = module.db[each.key].data[local.db_key].secret.iam_policy_arn_map["read"]
  }
  std_map = module.com_lib[each.key].std_map
}

module "app_user_role" {
  source            = "path/to/modules/iam/role/cognito/identity_pool"
  for_each          = local.env_list_instance
  cognito_data_map  = module.identity_pool[each.key].data
  identity_pool_key = "app_user"
  name              = "app_user"
  std_map           = module.com_lib[each.key].std_map
}
