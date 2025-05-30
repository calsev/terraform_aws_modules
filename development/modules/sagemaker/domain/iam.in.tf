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
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
