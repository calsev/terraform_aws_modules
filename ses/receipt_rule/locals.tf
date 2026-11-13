module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.rule_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      after                  = v.after == null ? var.rule_after_default : v.after
      enabled                = v.enabled == null ? var.rule_enabled_default : v.enabled
      lambda_function_arn    = v.lambda_function_arn == null ? var.rule_lambda_function_arn_default : v.lambda_function_arn
      lambda_invocation_type = v.lambda_invocation_type == null ? var.rule_lambda_invocation_type_default : v.lambda_invocation_type
      rule_set_name          = v.rule_set_name == null ? var.rule_rule_set_name_default : v.rule_set_name
      s3_bucket_name         = v.s3_bucket_name == null ? var.rule_s3_bucket_name_default : v.s3_bucket_name
      s3_object_key_prefix   = v.s3_object_key_prefix == null ? var.rule_s3_object_key_prefix_default : v.s3_object_key_prefix
      scan_enabled           = v.scan_enabled == null ? var.rule_scan_enabled_default : v.scan_enabled
      stop_after             = v.stop_after == null ? var.rule_stop_after_default : v.stop_after
      tls_required           = v.tls_required == null ? var.rule_tls_required_default : v.tls_required
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      # Actions run in position order: store the message, invoke the function, stop.
      # A function that reads the message from S3 needs the store to come first.
      lambda_position = local.l1_map[k].s3_bucket_name == null ? 1 : 2
      stop_position   = 1 + (local.l1_map[k].s3_bucket_name == null ? 0 : 1) + (local.l1_map[k].lambda_function_arn == null ? 0 : 1)
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        rule_arn  = aws_ses_receipt_rule.this_rule[k].arn
        rule_name = aws_ses_receipt_rule.this_rule[k].name
      },
    )
  }
}
