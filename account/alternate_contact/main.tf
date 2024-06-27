resource "aws_organizations_delegated_administrator" "this_delegation" {
  for_each          = local.create_delegate_map
  account_id        = each.key
  service_principal = "account.amazonaws.com"
}

resource "aws_account_alternate_contact" "this_contact" {
  for_each               = local.lx_map
  depends_on             = [aws_organizations_delegated_administrator.this_delegation]
  account_id             = each.value.account_id
  alternate_contact_type = each.value.alternate_contact_type
  email_address          = each.value.email_address
  name                   = each.value.name
  phone_number           = each.value.phone_number
  title                  = each.value.title
}
