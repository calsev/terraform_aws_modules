module "name_map" {
  source                = "../name_map"
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

locals {
  create_validation_1_map = {
    for k, v in local.lx_map : k => [
      for dvo in aws_acm_certificate.this_cert[k].domain_validation_options : merge(v, {
        dns_from_fqdn   = dvo.resource_record_name
        dns_record_list = [dvo.resource_record_value]
        dns_type        = dvo.resource_record_type
        k               = k
        k_validation    = replace("${k}${dvo.resource_record_name}", "-", "_")
      })
    ]
  }
  create_validation_2_list = flatten([
    for k, v in local.create_validation_1_map : [
      for v_validation in v : v_validation
    ]
  ])
  create_validation_x_map = {
    for v in local.create_validation_2_list : v.k_validation => v
  }
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      dns_from_zone_key           = v.dns_from_zone_key == null ? var.domain_dns_from_zone_key_default : v.dns_from_zone_key
      enable_transparency_logging = v.enable_transparency_logging == null ? var.domain_enable_transparency_logging_default : v.enable_transparency_logging
      key_algorithm               = v.key_algorithm == null ? var.domain_key_algorithm_default : v.key_algorithm
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        certificate_arn = aws_acm_certificate.this_cert[k].arn
        dns_challenge = [
          for v_validation in local.create_validation_1_map[k] : module.dns_challenge.data[v_validation.k_validation]
        ]
      }
    )
  }
}
