module "name_map" {
  source             = "../../../name_map"
  name_infix_default = false # <= 32 chars
  name_map           = local.l0_map
  std_map            = var.std_map
}

module "vpc_map" {
  source                              = "../../../vpc/id_map"
  vpc_map                             = local.l0_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  l0_map = {
    for k, v in var.host_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      provider_type       = v.provider_type == null ? var.host_provider_type_default == null : v.provider_type
      vpc_tls_certificate = v.vpc_tls_certificate == null ? var.host_vpc_tls_certificate_default : v.vpc_tls_certificate
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      {
        host_arn = aws_codestarconnections_host.this_host[k].arn
      },
    )
  }
}
