module "managed_policies" {
  source = "../../../iam/policy/managed"
  policy_map = {
    batch_service    = "service-role/AWSBatchServiceRole"
    batch_spot_fleet = "service-role/AmazonEC2SpotFleetTaggingRole"
    batch_submit_job = "service-role/AWSBatchServiceEventTargetRole"
  }
  std_map = var.std_map
}

module "batch_service_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["batch"]
  role_policy_attach_arn_map_default = {
    batch_service = module.managed_policies.data.iam_policy_arn_batch_service
  }
  name                            = "batch_service"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "batch_spot_fleet_role" {
  source                          = "../../../iam/role/base"
  assume_role_service_list        = ["spotfleet"]
  name                            = "batch_spot_fleet"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_policy_attach_arn_map_default = {
    batch_spot_fleet = module.managed_policies.data.iam_policy_arn_batch_spot_fleet
  }
  std_map = var.std_map
}
