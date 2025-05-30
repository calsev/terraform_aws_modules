
resource "aws_route53_zone" "this_zone" {
  for_each = local.lx_map
  name     = each.key
}

resource "aws_route53_record" "this_mx" {
  for_each = local.create_mx_map
  name     = "${each.key}."
  records  = each.value.mx_url_list
  ttl      = var.ttl_mx
  type     = "MX"
  zone_id  = aws_route53_zone.this_zone[each.key].zone_id
}

module "log_group" {
  source                     = "../../cw/log_group"
  log_map                    = local.create_log_map
  log_retention_days_default = var.log_retention_days_default
  name_prefix_default        = "/aws/route53/"
  std_map                    = var.std_map
}

resource "aws_route53_query_log" "this_log" {
  for_each                 = local.create_log_map
  cloudwatch_log_group_arn = module.log_group.data[each.key].log_group_arn
  zone_id                  = aws_route53_zone.this_zone[each.key].zone_id
}
