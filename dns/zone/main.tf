
resource "aws_route53_zone" "this_zone" {
  for_each = local.lx_map
  name     = each.key
}

resource "aws_route53_record" "this_mx" {
  for_each = local.mx_map
  name     = "${each.key}."
  records  = each.value.mx_url_list
  ttl      = var.ttl_mx
  type     = "MX"
  zone_id  = aws_route53_zone.this_zone[each.key].zone_id
}
