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
  name        = "batch_service"
  {{ name.map_item() }}
  std_map     = var.std_map
}

module "batch_spot_fleet_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["spotfleet"]
  name                     = "batch_spot_fleet"
  {{ name.map_item() }}
  role_policy_attach_arn_map_default = {
    batch_spot_fleet = module.managed_policies.data.iam_policy_arn_batch_spot_fleet
  }
  std_map = var.std_map
}
