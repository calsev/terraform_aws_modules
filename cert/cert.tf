resource "aws_acm_certificate" "this_cert" {
  for_each    = local.domain_map
  domain_name = each.key
  lifecycle {
    create_before_destroy = true
  }
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  subject_alternative_names = []
  tags = merge(
    var.std_map.tags,
    {
      Name = "${var.std_map.resource_name_prefix}${each.key}${var.std_map.resource_name_suffix}"
    }
  )
  validation_method = "DNS"
  validation_option {
    domain_name       = each.key
    validation_domain = each.value.validation_domain
  }
}

resource "aws_route53_record" "this_dns" {
  for_each = local.validation_map
  name     = each.value.name
  records  = [each.value.record]
  ttl      = var.dns_data.ttl_map.challenge
  type     = each.value.type
  zone_id  = var.dns_data.domain_to_dns_zone_map[each.value.validation_domain].dns_zone_id
}

resource "aws_acm_certificate_validation" "this_validation" {
  for_each                = local.validation_map
  certificate_arn         = aws_acm_certificate.this_cert[each.value.key].arn
  validation_record_fqdns = [for record in aws_route53_record.this_dns : record.fqdn]
}
