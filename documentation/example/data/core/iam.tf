module "db_proxy_role" {
  source                   = "path/to/modules/iam/role/base"
  for_each                 = local.env_list_db
  assume_role_service_list = ["rds"]
  name                     = "proxy"
  role_policy_attach_arn_map_default = {
    db_secret_read = module.db[each.key].data[local.db_key].secret.iam_policy_arn_map["read"]
  }
  std_map = module.com_lib[each.key].std_map
}
