module "config_role" {
  source                   = "../../iam/role/base"
  assume_role_service_list = ["config"]
  name                     = "config"
  role_policy_attach_arn_map_default = {
    log_write = var.s3_data_map[var.log_bucket_key].policy.iam_policy_arn_map["write"]
  }
  role_policy_managed_name_map_default = {
    resource_access = "service-role/AWS_ConfigRole"
  }
  std_map = var.std_map
}
