module "batch_service_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["batch"]
  policy_attach_arn_map = {
    batch_service = module.managed_policies.data.iam_policy_arn_batch_service
  }
  name        = "batch_service"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

module "batch_spot_fleet_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["spotfleet"]
  name                     = "batch_spot_fleet"
  name_prefix              = var.name_prefix
  policy_attach_arn_map = {
    batch_spot_fleet = module.managed_policies.data.iam_policy_arn_batch_spot_fleet
  }
  std_map = var.std_map
}
