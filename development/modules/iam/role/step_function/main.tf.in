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
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["states"]
  create_instance_profile  = false
  embedded_role_policy_attach_arn_map = {
    log_read = {
      policy = var.log_data.iam_policy_arn_map.read
    }
    log_write = {
      policy = var.log_data.iam_policy_arn_map.write
    }
  }
  embedded_role_policy_inline_json_map = {
    manage_log_policy = {
      policy = data.aws_iam_policy_document.manage_log_policy.json
    }
    trace_read_write = {
      policy = data.aws_iam_policy_document.x_ray_trace.json
    }
  }
  max_session_duration_m               = var.max_session_duration_m
  map_policy                           = var.map_policy
  name                                 = var.name
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
