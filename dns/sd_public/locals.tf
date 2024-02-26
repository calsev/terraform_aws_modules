module "name_map" {
  source   = "../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  create_ns_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_record_list = data.aws_route53_zone.this_zone[k].name_servers
    })
  }
  l0_map = {
    for k, v in var.zone_map : k => v
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
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        dns_ns      = module.this_ns.data[k]
        dns_zone_id = aws_service_discovery_public_dns_namespace.this_namespace[k].hosted_zone
        id          = aws_service_discovery_public_dns_namespace.this_namespace[k].id
      }
    )
  }
}
