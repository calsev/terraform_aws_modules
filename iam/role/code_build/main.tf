module "s3_log_policy" {
  for_each = var.log_bucket_name == null ? {} : { this = {} }
  source   = "../../../iam/policy/identity/s3/bucket"
  sid_map = {
    Log = {
      access           = "write"
      bucket_name_list = [var.log_bucket_name]
    }
  }
  std_map = var.std_map
}

module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["codebuild"]
  create_instance_profile  = false
  max_session_duration_m   = var.max_session_duration_m
  name                     = var.name
  name_prefix              = var.name_prefix
  name_infix               = var.name_infix
  policy_attach_arn_map    = local.attach_policy_arn_map_2
  policy_create_json_map   = var.policy_create_json_map
  policy_inline_json_map   = local.policy_inline_json_map
  policy_managed_name_map  = var.policy_managed_name_map
  role_path                = var.role_path
  std_map                  = var.std_map
  tag                      = var.tag
}
