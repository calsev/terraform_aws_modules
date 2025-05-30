{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.enabler_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      aws_account_id_list = v.aws_account_id_list == null ? var.enabler_aws_account_id_list_default == null ? [var.std_map.aws_account_id] : var.enabler_aws_account_id_list_default : v.aws_account_id_list
      resource_type_list  = v.resource_type_list == null ? var.enabler_resource_type_list_default : v.resource_type_list
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
