module "rds_monitoring_role" {
  source                          = "../../../iam/role/base"
  assume_role_service_list        = ["monitoring.rds"]
  name                            = "rds_monitor"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_policy_managed_name_map_default = {
    rds_monitor = "service-role/AmazonRDSEnhancedMonitoringRole"
  }
  std_map = var.std_map
}
