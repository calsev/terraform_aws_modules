module "mobile_analytics_policy" {
  source  = "../../../iam/policy/identity/mobile_analytics"
  name    = "mobile_analytics"
  {{ name.map_item() }}
  std_map = var.std_map
}

module "mobile_analytics_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["pinpoint"]
  role_policy_attach_arn_map_default = {
    batch_service = module.mobile_analytics_policy.data.iam_policy_arn_map["write"]
  }
  name        = "mobile_analytics"
  {{ name.map_item() }}
  std_map     = var.std_map
}
