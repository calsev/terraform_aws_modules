resource "aws_ses_receipt_rule_set" "this_rule_set" {
  for_each      = local.lx_map
  rule_set_name = each.value.name_effective
}

# SES applies only the active rule set, and an account has at most one per region
resource "aws_ses_active_receipt_rule_set" "this_active" {
  for_each      = local.create_active_map
  rule_set_name = aws_ses_receipt_rule_set.this_rule_set[each.key].rule_set_name
}
