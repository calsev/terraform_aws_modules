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
  embedded_role_policy_attach_arn_map = {
    artifact_read_write = {
      policy = var.ci_cd_account_data.bucket.iam_policy_arn_map.read_write
    }
    code_connection = {
      condition = var.code_star_connection_key != null
      policy    = var.code_star_connection_key == null ? null : var.ci_cd_account_data.code_star.connection[var.code_star_connection_key].iam_policy_arn_map.read_write
    }
    image_read_write = {
      condition = var.map_policy.image_ecr_repo_key != null
      policy    = var.map_policy.image_ecr_repo_key == null ? null : var.ecr_data_map[var.map_policy.image_ecr_repo_key].iam_policy_arn_map.read_write
    }
    log_write = {
      policy = var.log_public_access ? var.ci_cd_account_data.log_public.iam_policy_arn_map.write : var.ci_cd_account_data.log.iam_policy_arn_map.write
    }
    vpc_net = {
      condition = var.vpc_access
      policy    = var.vpc_access ? var.ci_cd_account_data.policy.vpc_net.iam_policy_arn : null
    }
  }
  embedded_role_policy_inline_json_map = {
    log_s3_write = {
      condition = var.log_bucket_name != null
      policy    = var.log_bucket_name == null ? null : jsonencode(module.s3_log_policy["this"].data.iam_policy_doc)
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  name_prefix                          = var.name_prefix
  name_infix                           = var.name_infix
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path                            = var.role_path
  std_map                              = var.std_map
}
