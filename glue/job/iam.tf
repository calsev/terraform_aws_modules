module "job_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.lx_map
  assume_role_service_list = ["glue"]
  embedded_role_policy_managed_name_map = {
    service = {
      policy = "service-role/AWSGlueServiceRole"
    }
  }
  map_policy                           = each.value
  name                                 = each.key
  name_prepend_default                 = "glue"
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path_default                    = var.role_path_default
  std_map                              = var.std_map
}
