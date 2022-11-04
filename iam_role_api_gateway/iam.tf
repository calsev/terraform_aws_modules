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
  assume_role_service_list = ["apigateway"]
  attach_policy_arn_map = merge(var.attach_policy_arn_map, {
    log_write = var.log_data.iam_policy_arn_map.write
  })
  create_instance_profile = false
  create_policy_json_map  = var.create_policy_json_map
  inline_policy_json_map = merge(var.inline_policy_json_map, {
    trace_read_write = data.aws_iam_policy_document.x_ray_trace.json
  })
  managed_policy_name_map = var.managed_policy_name_map
  max_session_duration    = var.max_session_duration
  name                    = var.name
  name_prefix             = var.name_prefix
  name_infix              = var.name_infix
  role_path               = var.role_path
  std_map                 = var.std_map
}
