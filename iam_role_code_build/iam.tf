module "assume_role_policy" {
  source       = "../iam_policy_assume_role"
  service_list = ["codebuild"]
  #  sid_map = {
  #    Role = {
  #      condition_map = {
  #        pipe_role_key_match = {
  #          test       = "StringLike" # ArnLike does not work
  #          value_list = ["arn:${var.std_map.iam_partition}:iam::${var.std_map.aws_account_id}:role/${var.code_pipe_role_key}"]
  #          variable   = "AWS:PrincipalArn" # SourceArn does not work
  #        }
  #      }
  #    }
  #  }
}

module "s3_log_policy" {
  for_each = var.log_bucket_name == null ? {} : { this = {} }
  source   = "../iam_policy_identity_s3"
  sid_map = {
    Log = {
      access           = "write"
      bucket_name_list = [var.log_bucket_name]
    }
  }
  std_map = var.std_map
}

module "this_role" {
  source                  = "../iam_role"
  assume_role_json        = jsonencode(module.assume_role_policy.iam_policy_doc_assume_role)
  create_instance_profile = false
  max_session_duration    = var.max_session_duration
  name                    = var.name
  name_prefix             = var.name_prefix
  name_infix              = var.name_infix
  policy_attach_arn_map   = local.attach_policy_arn_map_2
  policy_create_json_map  = var.policy_create_json_map
  policy_inline_json_map  = local.policy_inline_json_map
  policy_managed_name_map = var.policy_managed_name_map
  role_path               = var.role_path
  std_map                 = var.std_map
  tag                     = var.tag
}
