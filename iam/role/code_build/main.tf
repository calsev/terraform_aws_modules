module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["codebuild"]
  create_instance_profile  = false
  embedded_role_policy_attach_arn_map = {
    artifact_read_write = {
      policy = var.ci_cd_account_data.bucket.policy.policy_map["read_write"].iam_policy_arn
    }
    code_connection = {
      condition = var.code_star_connection_key != null
      policy    = var.code_star_connection_key == null ? null : var.ci_cd_account_data.code_star.connection[var.code_star_connection_key].policy_map["read_write"].iam_policy_arn
    }
    ecr_login = {
      condition = var.iam_data != null
      policy    = var.iam_data == null ? null : var.iam_data.iam_policy_arn_ecr_get_token
    }
    image_read_write = {
      condition = var.map_policy.image_ecr_repo_key != null
      policy    = var.map_policy.image_ecr_repo_key == null ? null : var.ecr_data_map[var.map_policy.image_ecr_repo_key].policy_map["read_write"].iam_policy_arn
    }
    log_s3_write = {
      condition = var.log_bucket_key != null
      policy    = var.log_bucket_key == null ? null : var.s3_data_map[var.log_bucket_key].policy.policy_map["write"].iam_policy_arn
    }
    log_write = {
      policy = var.log_public_access ? var.ci_cd_account_data.log_public.policy_map["write"].iam_policy_arn : var.ci_cd_account_data.log.policy_map["write"].iam_policy_arn
    }
    vpc_net = {
      condition = var.vpc_access
      policy    = var.vpc_access ? var.ci_cd_account_data.policy.vpc_net.iam_policy_arn : null
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
