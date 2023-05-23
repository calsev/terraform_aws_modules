data "aws_iam_policy_document" "manage_log_policy" {
  # This is a special "management" permission that is required for step functions
  statement {
    actions = [
      "logs:DescribeResourcePolicies",
      "logs:GetLogDelivery",
      "logs:ListLogDeliveries",
    ]
    resources = ["*"]
    sid       = "LogManagementRead"
  }
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:PutResourcePolicy",
      "logs:UpdateLogDelivery",
    ]
    resources = ["*"]
    sid       = "LogManagementWrite"
  }
}

data "aws_iam_policy_document" "x_ray_trace" {
  statement {
    actions   = var.std_map.service_resource_access_action.xray.star.read
    resources = ["*"]
    sid       = "TraceRead"
  }
  statement {
    actions   = var.std_map.service_resource_access_action.xray.star.write
    resources = ["*"]
    sid       = "TraceWrite"
  }
}

module "this_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["states"]
  create_instance_profile  = false
  max_session_duration_m   = var.max_session_duration_m
  name                     = var.name
  name_prefix              = var.name_prefix
  name_infix               = var.name_infix
  policy_attach_arn_map = merge(var.policy_attach_arn_map, {
    log_read  = var.log_data.iam_policy_arn_map.read
    log_write = var.log_data.iam_policy_arn_map.write
  })
  policy_create_json_map = var.policy_create_json_map
  policy_inline_json_map = merge(var.policy_inline_json_map, {
    manage_log_policy = data.aws_iam_policy_document.manage_log_policy.json
    trace_read_write  = data.aws_iam_policy_document.x_ray_trace.json
  })
  policy_managed_name_map = var.policy_managed_name_map
  role_path               = var.role_path
  std_map                 = var.std_map
}
