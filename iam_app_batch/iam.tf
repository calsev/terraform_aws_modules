module "batch_service_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["batch"]
  attach_policy_arn_map = {
    batch_service = module.managed_policies.data.iam_policy_arn_batch_service
  }
  name        = "batch_service"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

module "batch_spot_fleet_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["spotfleet"]
  attach_policy_arn_map = {
    batch_spot_fleet = module.managed_policies.data.iam_policy_arn_batch_spot_fleet
  }
  name        = "batch_spot_fleet"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

module "batch_submit_job_role" {
  source                   = "../iam_role"
  assume_role_service_list = var.std_map.task_starter_service_list
  attach_policy_arn_map = {
    batch_submit_job = module.managed_policies.data.iam_policy_arn_batch_submit_job
  }
  name        = "submit_batch_job"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}