module "name_map" {
  source   = "../../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.service_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
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
        role_arn       = aws_iam_service_linked_role.this_role[k].arn
        role_id        = aws_iam_service_linked_role.this_role[k].id
        role_unique_id = aws_iam_service_linked_role.this_role[k].unique_id
      }
    )
  }
}
