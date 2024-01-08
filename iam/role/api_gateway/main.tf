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
  assume_role_service_list = ["apigateway"]
  create_instance_profile  = false
  max_session_duration_m   = var.max_session_duration_m
  name                     = var.name
  name_prefix              = var.name_prefix
  name_infix               = var.name_infix
  policy_attach_arn_map = merge(var.policy_attach_arn_map, {
    log_write = var.log_data.iam_policy_arn_map.write
  })
  policy_create_json_map = var.policy_create_json_map
  policy_inline_json_map = merge(var.policy_inline_json_map, {
    trace_read_write = data.aws_iam_policy_document.x_ray_trace.json
  })
  policy_managed_name_map = var.policy_managed_name_map
  role_path               = var.role_path
  std_map                 = var.std_map
}
