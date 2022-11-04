locals {
  connection_map = {
    for k, v in var.connection_map : k => {
      host_key      = v.host_key
      name          = replace(k, "_", "-") # <= 32 chars
      provider_type = v.provider_type == null ? var.connection_provider_type_default : v.provider_type
      resource_name = local.resource_name_map[k]
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k],
        }
      )
    }
  }
  resource_name_map = {
    for k, _ in var.connection_map : k => "${var.std_map.resource_name_prefix}${replace(k, "_", "-")}${var.std_map.resource_name_suffix}"
  }
  host_map = {
    for k, v in var.host_map : k => merge(v, {
      provider_type = v.provider_type == null ? var.host_provider_type_default : v.provider_type
      resource_name = "${var.std_map.resource_name_prefix}${replace(k, "_", "-")}${var.std_map.resource_name_suffix}"
    })
  }
  output_data = {
    connection = {
      for k, _ in var.connection_map : k => merge(module.connection_policy[k].data, {
        arn = aws_codestarconnections_connection.this_codestar[k].arn
      })
    }
    host = {
      for k, _ in var.host_map == null ? {} : var.host_map : k => {
        arn = aws_codestarconnections_host.this_host[k].arn
      }
    }
  }
}
