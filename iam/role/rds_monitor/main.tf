module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["monitoring.rds"]
  embedded_role_policy_managed_name_map = {
    write_cw_metrics = {
      policy = "service-role/AmazonRDSEnhancedMonitoringRole"
    }
  }
  name        = "rds_monitoring"
  name_prefix = var.name_prefix
  name_infix  = var.name_infix
  role_path   = var.role_path
  std_map     = var.std_map
}
