locals {
  output_data = {
    security_group_id_map = {
      for k, v in var.security_group_map : k => aws_security_group.this_sg[k].id
    }
    security_group_map = {
      for k, v in var.security_group_map : k => merge(v, {
        id = aws_security_group.this_sg[k].id
      })
    }
  }
  sg_name = {
    for k, _ in var.security_group_map : k => replace(k, "_", "-")
  }
  sg_name_prefix = "${var.std_map.resource_name_prefix}${var.vpc_data.vpc_name}-"
  sg_name_suffix = var.std_map.resource_name_suffix
  sg_rule_flattened_list = flatten([for k_sg, v_sg in var.security_group_map :
    flatten([for k_rule, v_rule in v_sg.rules : {
      k_sg   = k_sg
      k_rule = k_rule
      v_rule = v_rule
    }])
  ])
  sg_rule_flattened_map = {
    for sg_rule in local.sg_rule_flattened_list : "${replace(sg_rule.k_sg, "_", "-")}-${replace(sg_rule.k_rule, "_", "-")}" => sg_rule
  }
}
