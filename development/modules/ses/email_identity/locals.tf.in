module "name_map" {
  source                = "../../name_map"
  name_map              = var.domain_map
  std_map               = var.std_map
  name_regex_allow_list = ["."]
}

locals {
  l1_map = {
    for k, v in var.domain_map : k => merge(v, module.name_map.data[k], {
      configuration_set_key    = v.configuration_set_key == null ? var.domain_configuration_set_key_default : v.configuration_set_key
      email_forwarding_enabled = v.email_forwarding_enabled == null ? var.domain_email_forwarding_enabled_default : v.email_forwarding_enabled
    })
  }
  l2_map = {
    for k, v in var.domain_map : k => {
      configuration_set_name = local.l1_map[k].configuration_set_key == null ? null : var.config_data_map[local.l1_map[k].configuration_set_key].configuration_set_name
    }
  }
  output_data = {
    for k, v in var.domain_map : k => merge(
      {
        for k_attr, v_attr in local.domain_map[k] : k_attr => v_attr if !contains([], k_attr)
      },
      {
        identity_arn = aws_sesv2_email_identity.this_domain[k].arn
      },
    )
  }
  domain_map = {
    for k, v in var.domain_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
