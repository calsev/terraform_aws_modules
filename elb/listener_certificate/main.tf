resource "aws_lb_listener_certificate" "this_cert" {
  for_each        = local.create_cert_map
  certificate_arn = each.value.acm_certificate_arn
  listener_arn    = each.value.elb_listener_arn
}

module "dns_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.listener_dns_from_zone_key_default
  record_map                       = local.create_dns_x_map
  std_map                          = var.std_map
}
