locals {
  output_data = {
    iam_role_arn_rds_monitor  = module.rds_monitoring_role.data.iam_role_arn
    iam_role_data_rds_monitor = module.rds_monitoring_role.data
  }
}
