{{ name.map() }}

locals {
  create_delegate_map = {
    for k, v in local.lx_map : v.account_id => v... if v.account_id != var.std_map.aws_account_id
  }
  l0_map = {
    for k, v in var.contact_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      account_id             = v.account_id == null ? var.contact_account_id_default == null ? var.std_map.aws_account_id : var.contact_account_id_default : v.account_id
      alternate_contact_type = v.alternate_contact_type == null ? var.contact_alternate_contact_type_default == null ? k : var.contact_alternate_contact_type_default : v.alternate_contact_type
      contact_name           = v.contact_name == null ? var.contact_name_default : v.contact_name
      email_address          = v.email_address == null ? var.contact_email_address_default : v.email_address
      phone_number           = v.phone_number == null ? var.contact_phone_number_default : v.phone_number
      title                  = v.title == null ? var.contact_title_default : v.title
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
      }
    )
  }
}
