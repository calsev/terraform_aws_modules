module "rds_monitoring_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["monitoring.rds"]
  name                     = "rds_monitor"
  {{ name.map_item() }}
  role_policy_managed_name_map_default = {
    rds_monitor = "service-role/AmazonRDSEnhancedMonitoringRole"
  }
  std_map = var.std_map
}
