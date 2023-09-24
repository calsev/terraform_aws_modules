module "mobile_analytics_policy" {
  source  = "../iam_policy_identity_mobile_analytics"
  name    = "mobile_analytics"
  std_map = var.std_map
}

module "mobile_analytics_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["pinpoint"]
  policy_attach_arn_map = {
    batch_service = module.mobile_analytics_policy.data.iam_policy_arn_map["write"]
  }
  name        = "mobile_analytics"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}
