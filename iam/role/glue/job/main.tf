module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["glue"]
  create_instance_profile  = false
  embedded_role_policy_managed_name_map = {
    glue_service = {
      policy = "service-role/AWSGlueServiceRole"
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  name_append_default                  = var.name_append_default
  name_include_app_fields_default      = var.name_include_app_fields_default
  name_infix_default                   = var.name_infix_default
  name_prefix_default                  = var.name_prefix_default
  name_prepend_default                 = var.name_prepend_default
  name_suffix_default                  = var.name_suffix_default
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path_default                    = var.role_path_default
  std_map                              = var.std_map
}
