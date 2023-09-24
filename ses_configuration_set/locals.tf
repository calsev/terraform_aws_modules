module "name_map" {
  source   = "../name_map"
  name_map = var.config_map
  std_map  = var.std_map
}

locals {
  config_map = {
    for k, v in var.config_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l1_map = {
    for k, v in var.config_map : k => merge(v, module.name_map.data[k], {
      auto_suppress_address_reason_list              = v.auto_suppress_address_reason_list == null ? var.config_auto_suppress_address_reason_list_default : v.auto_suppress_address_reason_list
      reputation_metrics_enabled                     = v.reputation_metrics_enabled == null ? var.config_reputation_metrics_enabled_default : v.reputation_metrics_enabled
      sending_enabled                                = v.sending_enabled == null ? var.config_sending_enabled_default : v.sending_enabled
      sending_pool_name                              = v.sending_pool_name == null ? var.config_sending_pool_name_default : v.sending_pool_name
      tls_required                                   = v.tls_required == null ? var.config_tls_required_default : v.tls_required
      tracking_custom_redirect_domain                = v.tracking_custom_redirect_domain == null ? var.config_tracking_custom_redirect_domain_default : v.tracking_custom_redirect_domain
      vdm_dashboard_engagement_metrics_enabled       = v.vdm_dashboard_engagement_metrics_enabled == null ? var.config_vdm_dashboard_engagement_metrics_enabled_default : v.vdm_dashboard_engagement_metrics_enabled
      vdm_guardian_optimized_shared_delivery_enabled = v.vdm_guardian_optimized_shared_delivery_enabled == null ? var.config_vdm_guardian_optimized_shared_delivery_enabled_default : v.vdm_guardian_optimized_shared_delivery_enabled
    })
  }
  l2_map = {
    for k, v in var.config_map : k => {
    }
  }
  output_data = {
    for k, v in var.config_map : k => merge(
      {
        for k_attr, v_attr in local.config_map[k] : k_attr => v_attr if !contains([], k_attr)
      },
      {
        arn                    = aws_sesv2_configuration_set.this_config[k].arn
        configuration_set_name = aws_sesv2_configuration_set.this_config[k].configuration_set_name
      },
    )
  }
}
