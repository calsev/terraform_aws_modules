data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
    sid = "ServiceAssumeRole"
  }
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    condition {
      test     = "StringLike" # ArnLike does not work
      values   = ["arn:${var.std_map.iam_partition}:iam::${var.std_map.aws_account_id}:role/${var.code_pipe_role_key}"]
      variable = "AWS:PrincipalArn" # SourceArn does not work
    }
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    sid = "RoleAssumeRole"
  }
}

module "s3_log_policy" {
  for_each = var.log_bucket_name == null ? {} : { this = {} }
  source   = "../iam_policy_role_s3"
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
  assume_role_json        = data.aws_iam_policy_document.assume_role_policy.json
  attach_policy_arn_map   = local.attach_policy_arn_map
  create_instance_profile = false
  create_policy_json_map  = var.create_policy_json_map
  inline_policy_json_map  = local.inline_policy_json_map
  managed_policy_name_map = var.managed_policy_name_map
  max_session_duration    = var.max_session_duration
  name                    = var.name
  name_prefix             = var.name_prefix
  name_infix              = var.name_infix
  role_path               = var.role_path
  std_map                 = var.std_map
  tag                     = var.tag
}
