locals {
  output_data = merge(module.managed_policies.data, {
    iam_role_arn_batch_service     = module.batch_service_role.data.iam_role_arn
    iam_role_arn_batch_spot_fleet  = module.batch_spot_fleet_role.data.iam_role_arn
    iam_role_data_batch_service    = module.batch_service_role.data
    iam_role_data_batch_spot_fleet = module.batch_spot_fleet_role.data
  })
}
