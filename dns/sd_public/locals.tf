locals {
  resource_name_map = {
    for zone in var.zone_list : zone.fqdn => "${var.std_map.resource_name_prefix}${replace(zone.fqdn, ".", "-")}${var.std_map.resource_name_suffix}"
  }
  zone_map = {
    for zone in var.zone_list : zone.fqdn => {
      dns_zone_id_parent = zone.dns_zone_id_parent
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[zone.fqdn]
        }
      )
    }
  }
  zone_object = {
    for zone in var.zone_list : zone.fqdn => {
      dns_zone_id = aws_service_discovery_public_dns_namespace.this_namespace[zone.fqdn].hosted_zone
      id          = aws_service_discovery_public_dns_namespace.this_namespace[zone.fqdn].id
    }
  }
}
