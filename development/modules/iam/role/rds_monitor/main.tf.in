module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["monitoring.rds"]
  embedded_role_policy_managed_name_map = {
    write_cw_metrics = {
      policy = "service-role/AmazonRDSEnhancedMonitoringRole"
    }
  }
  name        = "rds_monitoring"
  {{ name.map_item() }}
  role_path_default = var.role_path_default
  std_map           = var.std_map
}
