module "service_role" {
  source = "../../iam/role/service_linked"
  service_map = {
    config = {}
  }
  std_map = var.std_map
}

resource "aws_config_retention_configuration" "retention" {
  retention_period_in_days = var.record_retention_period_days
}

module "config_recorder" {
  source                          = "../../config/recorder"
  name_include_app_fields_default = false
  record_iam_role_arn_default     = module.service_role.data["config"].role_arn
  record_map = {
    default = {}
  }
  record_s3_bucket_key_default = var.s3_bucket_key
  s3_data_map                  = var.s3_data_map
  std_map                      = var.std_map
}
