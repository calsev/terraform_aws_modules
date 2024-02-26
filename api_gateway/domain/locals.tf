module "name_map" {
  source                = "../../name_map"
  name_infix_default    = false
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

locals {
  create_alias_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_alias_name    = aws_apigatewayv2_domain_name.this_domain[k].domain_name_configuration[0].target_domain_name
      dns_alias_zone_id = aws_apigatewayv2_domain_name.this_domain[k].domain_name_configuration[0].hosted_zone_id
    })
  }
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      certificate_arn = var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][k].certificate_arn
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
        dns_alias  = module.this_dns_alias.data[k]
        domain_arn = aws_apigatewayv2_domain_name.this_domain[k].arn
        domain_id  = aws_apigatewayv2_domain_name.this_domain[k].id
      }
    )
  }
}
