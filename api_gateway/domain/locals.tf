module "name_map" {
  source             = "../../name_map"
  name_infix_default = false
  name_map           = var.domain_map
  std_map            = var.std_map
}

locals {
  domain_map = {
    for k, v in var.domain_map : k => merge(v, module.name_map.data[k], {
      validation_domain = v.validation_domain == null ? var.domain_validation_domain_default : v.validation_domain
    })
  }
  output_data = {
    for k, v in local.domain_map : k => merge(v, {
      domain_arn = aws_apigatewayv2_domain_name.this_domain[k].arn
      domain_id  = aws_apigatewayv2_domain_name.this_domain[k].id
    })
  }
}
