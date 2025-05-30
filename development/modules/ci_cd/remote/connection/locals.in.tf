{{ name.map() }}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      connection_arn      = aws_codestarconnections_connection.this_codestar[k].arn
      connection_host_arn = aws_codestarconnections_connection.this_codestar[k].host_arn
    })
  }
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
      module.connection_policy.data[k],
      {
        connection_arn = aws_codestarconnections_connection.this_codestar[k].arn
      },
    )
  }
}
