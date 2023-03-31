module "name_map" {
  source             = "../name_map"
  name_infix_default = false # <= 32 chars
  name_map           = var.connection_map
  std_map            = var.std_map
}

locals {
  c1_map = {
    for k, v in var.connection_map : k => merge(v, module.name_map.data[k], {
      provider_type = v.provider_type == null ? var.connection_provider_type_default : v.provider_type
    })
  }
  connection_map = {
    for k, v in var.connection_map : k => merge(local.c1_map[k])
  }
  h1_map = {
    for k, v in var.host_map : k => merge(v, module.vpc_map.data[k], {
      name_context        = "${var.std_map.resource_name_prefix}${replace(k, "_", "-")}${var.std_map.resource_name_suffix}"
      provider_type       = v.provider_type == null ? var.host_provider_type_default : v.provider_type
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
