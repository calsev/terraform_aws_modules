module "name_map" {
  source                          = "../../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prepend_default            = var.name_prepend_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.account_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      close_on_deletion_enabled          = v.close_on_deletion_enabled == null ? var.account_close_on_deletion_enabled_default : v.close_on_deletion_enabled
      create_govcloud                    = v.create_govcloud == null ? var.account_create_govcloud_default : v.create_govcloud
      email_address                      = v.email_address == null ? var.account_email_address_default : v.email_address
      iam_user_access_to_billing_allowed = v.iam_user_access_to_billing_null ? null : v.iam_user_access_to_billing_allowed == null ? var.account_iam_user_access_to_billing_allowed_default : v.iam_user_access_to_billing_allowed
      parent_id                          = v.parent_id == null ? var.account_parent_id_default : v.parent_id
      role_name                          = v.role_name == null ? var.account_role_name_default : v.role_name
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
        account_arn         = aws_organizations_account.this[k].arn
        account_govcloud_id = aws_organizations_account.this[k].govcloud_id
        account_id          = aws_organizations_account.this[k].id
        account_status      = aws_organizations_account.this[k].status
      }
    )
  }
}
