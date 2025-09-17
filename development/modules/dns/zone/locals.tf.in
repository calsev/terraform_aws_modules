locals {
  create_log_map = {
    for k, v in local.lx_map : k => v if v.logging_enabled
  }
  create_mx_map = {
    for k, v in local.lx_map : k => v if v.mx_url_list != null
  }
  l0_map = {
    for k, v in var.domain_to_dns_zone_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      logging_enabled = v.logging_enabled == null ? var.domain_logging_enabled_default : v.logging_enabled
      mx_url_list     = v.mx_url_list == null ? var.domain_mx_url_list_default : v.mx_url_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      mx_url_list = local.l1_map[k].mx_url_list == null ? null : [
        for url in local.l1_map[k].mx_url_list : "${trim(url, ".")}."
      ]
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
        dns_zone_id = aws_route53_zone.this_zone[k].zone_id
        log         = v.logging_enabled ? module.log_group.data[k] : null
      }
    )
  }
}
