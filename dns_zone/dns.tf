
resource "aws_route53_zone" "this_zone" {
  for_each = var.domain_to_dns_zone_map
  name     = each.key
}

resource "aws_route53_record" "this_mx" {
  for_each = var.domain_to_dns_zone_map
  name     = "${each.key}."
  records  = local.google_mx_url_list
  ttl      = local.ttl_mx
  type     = "MX"
  zone_id  = aws_route53_zone.this_zone[each.key].zone_id
}
