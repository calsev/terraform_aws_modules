module "name_map" {
  source             = "../../../name_map"
  name_infix_default = false # <= 32 chars
  name_map           = local.l0_map
  std_map            = var.std_map
}

locals {
  l0_map = {
    for k, v in var.connection_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      host_key      = v.host_key == null ? var.connection_host_key_default : v.host_key
      provider_type = v.provider_type == null ? var.connection_provider_type_default : v.provider_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      host_arn = local.l1_map[k].host_key == null ? null : var.host_data_map[local.l1_map[k].host_key].host_arn
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      module.connection_policy[k].data,
      {
        connection_arn = aws_codestarconnections_connection.this_codestar[k].arn
      },
    )
  }
}
