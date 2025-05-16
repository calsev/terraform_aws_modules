module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["monitoring.rds"]
  embedded_role_policy_managed_name_map = {
    write_cw_metrics = {
      policy = "service-role/AmazonRDSEnhancedMonitoringRole"
    }
  }
  name                            = "rds_monitoring"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_path_default               = var.role_path_default
  std_map                         = var.std_map
}
