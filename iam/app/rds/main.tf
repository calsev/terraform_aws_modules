module "rds_monitoring_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["monitoring.rds"]
  name                     = "rds_monitor"
  name_prefix              = var.name_prefix
  policy_managed_name_map = {
    rds_monitor = "service-role/AmazonRDSEnhancedMonitoringRole"
  }
  std_map = var.std_map
}
