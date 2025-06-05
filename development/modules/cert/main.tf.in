resource "aws_acm_certificate" "this_cert" {
  for_each      = local.lx_map
  domain_name   = each.value.name_simple
  key_algorithm = each.value.key_algorithm
  lifecycle {
    create_before_destroy = true
  }
  options {
    certificate_transparency_logging_preference = each.value.enable_transparency_logging ? "ENABLED" : "DISABLED"
  }
  subject_alternative_names = each.value.subject_alternative_name_list
  tags                      = each.value.tags
  validation_method         = "DNS"
  validation_option {
    domain_name       = each.value.name_simple
    validation_domain = each.value.dns_from_zone_key
  }
}

module "dns_challenge" {
  source                           = "../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_map                       = local.create_challenge_x_map
  std_map                          = var.std_map
}

resource "aws_acm_certificate_validation" "this_validation" {
  for_each                = local.create_validation_x_map
  certificate_arn         = aws_acm_certificate.this_cert[each.value.k].arn
  validation_record_fqdns = [each.value.dns_from_fqdn]
}
