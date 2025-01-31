module "domain_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.create_role_map
  assume_role_service_list = ["sagemaker"]
  embedded_role_policy_attach_arn_map = {
    kms_key_usage = {
      policy = each.value.iam_policy_arn_kms_key_read_write
    }
    s3_artifact_storage = {
      policy = each.value.iam_policy_arn_s3_bucket_read_write
    }
  }
  map_policy                           = each.value
  name                                 = each.key
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  std_map                              = var.std_map
}
