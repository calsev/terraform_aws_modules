module "start_build" {
  source                  = "../../../iam/policy/identity/code_build/project"
  access_list             = ["read_write"]
  build_project_name_list = var.build_name_list
  name                    = var.name == null ? null : "${var.name}_start_build"
  name_infix              = var.name_infix
  name_prefix             = var.name_prefix
  std_map                 = var.std_map
}

module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["codepipeline"]
  create_instance_profile  = false
  max_session_duration_m   = var.max_session_duration_m
  name                     = var.name
  name_infix               = var.name_infix
  name_prefix              = var.name_prefix
  policy_attach_arn_map    = local.attach_policy_arn_map
  policy_create_json_map   = var.policy_create_json_map
  policy_inline_json_map   = var.policy_inline_json_map
  policy_managed_name_map  = var.policy_managed_name_map
  role_path                = var.role_path
  std_map                  = var.std_map
}
