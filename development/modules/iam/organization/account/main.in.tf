resource "aws_organizations_account" "this" {
  for_each                   = local.lx_map
  close_on_deletion          = each.value.close_on_deletion_enabled
  create_govcloud            = each.value.create_govcloud
  email                      = each.value.email_address
  iam_user_access_to_billing = each.value.iam_user_access_to_billing_allowed == null ? null : each.value.iam_user_access_to_billing_allowed ? "ALLOW" : "DENY"
  name                       = each.value.name_effective
  parent_id                  = each.value.parent_id
  role_name                  = each.value.role_name
  tags                       = each.value.tags
}
