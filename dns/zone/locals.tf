locals {
  dns_zone_object = {
    for k, _ in var.domain_to_dns_zone_map : k => {
      dns_zone_id = aws_route53_zone.this_zone[k].zone_id
    }
  }
  google_mx_url_list = [
    "5 gmr-smtp-in.l.google.com",
    "10 alt1.gmr-smtp-in.l.google.com",
    "20 alt2.gmr-smtp-in.l.google.com",
    "30 alt3.gmr-smtp-in.l.google.com",
    "40 alt4.gmr-smtp-in.l.google.com",
  ]
  ttl_mx = 3600
}
