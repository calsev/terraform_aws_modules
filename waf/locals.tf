module "name_map" {
  source   = "../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.waf_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      rate_limit_ip_5_minute = v.rate_limit_ip_5_minute == null ? var.waf_rate_limit_ip_5_minute_default : v.rate_limit_ip_5_minute
      scope                  = v.scope == null ? var.waf_scope_default : v.scope
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      rate_limit_ip_rule_name = "${local.l1_map[k].name_simple}-ip"
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      rate_limit_ip_rule_metric_name = "waf-${local.l2_map[k].rate_limit_ip_rule_name}"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        waf_arn = aws_wafv2_web_acl.this_waf_acl[k].arn
      }
    )
  }
}
