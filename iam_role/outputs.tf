output "data" {
  value = {
    assume_role_doc          = jsondecode(local.assume_role_json)
    assume_role_service_list = var.assume_role_service_list
    attach_policy_arn_map    = var.attach_policy_arn_map
    create_policy_doc_map = {
      for k, v in var.create_policy_json_map : k => jsondecode(v)
    }
    inline_policy_doc_map = {
      for k, v in local.inline_policy_json_map : k => jsondecode(v)
    }
    managed_policy_arn_map   = local.managed_policy_arn_map
    max_session_duration     = var.max_session_duration
    iam_instance_profile_arn = var.create_instance_profile ? aws_iam_instance_profile.instance_profile["this"].arn : null
    iam_role_arn             = aws_iam_role.this_iam_role.arn
    iam_role_id              = aws_iam_role.this_iam_role.id
  }
}
