locals {
  domain_map = {
    for k, v in var.domain_map : k => merge(v, {
      validation_domain = v.validation_domain == null ? var.domain_validation_domain_default : v.validation_domain
    })
  }
  output_data = {
    for k, _ in var.domain_map : k => {
      arn = aws_acm_certificate.this_cert[k].arn
    }
  }
  validation_list = flatten([
    for k, v in local.domain_map : [
      for dvo in aws_acm_certificate.this_cert[k].domain_validation_options : [
        merge(v, {
          domain_name = dvo.domain_name
          key         = k
          name        = dvo.resource_record_name
          record      = dvo.resource_record_value
          type        = dvo.resource_record_type
        })
      ]
    ]
  ])
  validation_map = {
    for v in local.validation_list : "${v.key}-${v.domain_name}" => v
  }
}
