{{ name.map() }}

locals {
  create_log_map = {
    for k, v in local.lx_map : k => v if v.log_group_key != null
  }
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
      dns_from_zone_key = v.dns_from_zone_key == null ? var.zone_dns_from_zone_key_default : v.dns_from_zone_key
      log_group_key     = v.log_group_key == null ? var.zone_log_group_key_default : v.log_group_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      log_group_arn = local.l1_map[k].log_group_key == null ? null : var.log_data_map[local.l1_map[k].log_group_key].log_group_arn
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
        dns_ns       = module.this_ns.data[k]
        dns_zone_id  = aws_service_discovery_public_dns_namespace.this_namespace[k].hosted_zone
        namespace_id = aws_service_discovery_public_dns_namespace.this_namespace[k].id
      }
    )
  }
}
