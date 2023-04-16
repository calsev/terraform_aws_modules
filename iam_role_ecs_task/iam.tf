module "this_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["ecs-tasks"]
  create_instance_profile  = false
  max_session_duration     = var.max_session_duration
  name                     = var.name
  name_prefix              = var.name_prefix
  name_infix               = var.name_infix
  policy_attach_arn_map = merge(var.policy_attach_arn_map, {
    log_write = var.log_data.iam_policy_arn_map.write
  })
  policy_create_json_map  = var.policy_create_json_map
  policy_inline_json_map  = var.policy_inline_json_map
  policy_managed_name_map = var.policy_managed_name_map
  role_path               = var.role_path
  std_map                 = var.std_map
}
