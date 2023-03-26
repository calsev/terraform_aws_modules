locals {
  c1_map = {
    for k, v in var.connection_map : k => merge(v, {
      name          = replace(k, "_", "-") # <= 32 chars
      provider_type = v.provider_type == null ? var.connection_provider_type_default : v.provider_type
    })
  }
  c2_map = {
    for k, v in var.connection_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.c1_map[k].name}${var.std_map.resource_name_suffix}"
    }
  }
  c3_map = {
    for k, v in var.connection_map : k => {
      tags = merge(
        var.std_map.tags,
        {
          Name = local.c2_map[k].resource_name,
        }
      )
    }
  }
  connection_map = {
    for k, v in var.connection_map : k => merge(local.c1_map[k], local.c2_map[k], local.c3_map[k])
  }
  h1_map = {
    for k, v in var.host_map : k => merge(v, module.vpc_map.data[k], {
      provider_type       = v.provider_type == null ? var.host_provider_type_default : v.provider_type
      resource_name       = "${var.std_map.resource_name_prefix}${replace(k, "_", "-")}${var.std_map.resource_name_suffix}"
      vpc_tls_certificate = v.vpc_tls_certificate == null ? var.host_vpc_tls_certificate_default : v.vpc_tls_certificate
    })
  }
  h2_map = {
    for k, v in var.host_map : k => merge(v, {
      vpc_id = local.h1_map[k].vpc_key == null ? null : var.vpc_data_map[local.h1_map[k].vpc_key].vpc_id
    })
  }
  host_map = {
    for k, v in var.host_map : k => merge(local.h1_map[k], local.h2_map[k])
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
