module "log_write_policy" {
  source = "../../iam/policy/identity/s3/bucket"
  sid_map = {
    Log = {
      access           = "write"
      bucket_name_list = [var.log_bucket_name]
    }
  }
  std_map = var.std_map
}

module "config_role" {
  source                   = "../../iam/role/base"
  assume_role_service_list = ["config"]
  name                     = "config"
  role_policy_inline_json_map_default = {
    log_write = jsonencode(module.log_write_policy.data.iam_policy_doc)
  }
  role_policy_managed_name_map_default = {
    resource_access = "service-role/AWS_ConfigRole"
  }
  std_map = var.std_map
}
