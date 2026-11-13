# SES checks the actions' permissions when it creates the rule: the bucket policy must
# let ses.amazonaws.com put objects under the prefix, and the function must have a
# permission for ses.amazonaws.com. Both are scoped to this rule's ARN, so a caller
# builds that ARN from the rule set and rule names and creates them first.
resource "aws_ses_receipt_rule" "this_rule" {
  for_each      = local.lx_map
  after         = each.value.after
  enabled       = each.value.enabled
  name          = each.value.name_effective
  recipients    = each.value.recipient_list
  rule_set_name = each.value.rule_set_name
  scan_enabled  = each.value.scan_enabled
  tls_policy    = each.value.tls_required ? "Require" : "Optional"
  dynamic "s3_action" {
    for_each = each.value.s3_bucket_name == null ? {} : { this = {} }
    content {
      bucket_name       = each.value.s3_bucket_name
      object_key_prefix = each.value.s3_object_key_prefix
      position          = 1
    }
  }
  dynamic "lambda_action" {
    for_each = each.value.lambda_function_arn == null ? {} : { this = {} }
    content {
      function_arn    = each.value.lambda_function_arn
      invocation_type = each.value.lambda_invocation_type
      position        = each.value.lambda_position
    }
  }
  dynamic "stop_action" {
    for_each = each.value.stop_after ? { this = {} } : {}
    content {
      position = each.value.stop_position
      scope    = "RuleSet"
    }
  }
}
