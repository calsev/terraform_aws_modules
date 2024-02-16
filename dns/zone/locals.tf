locals {
  l1_map = {
    for k, v in var.domain_to_dns_zone_map : k => {
      mx_url_list = v.mx_url_list == null ? var.domain_mx_url_list_default : v.mx_url_list
    }
  }
  lx_map = {
    for k, v in var.domain_to_dns_zone_map : k => {
      mx_url_list = [
        for url in local.l1_map[k].mx_url_list : "${trim(url, ".")}."
      ]
    }
  }
  mx_map = {
    for k, v in local.lx_map : k => v if v.mx_url_list != null
  }
  output_data = {
    for k, v in local.lx_map : k => merge(v, {
      dns_zone_id = aws_route53_zone.this_zone[k].zone_id
    })
  }
}
