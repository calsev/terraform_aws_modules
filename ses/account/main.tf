resource "aws_sesv2_account_suppression_attributes" "this" {
  for_each           = local.lx_map
  region             = var.std_map.aws_region_name
  suppressed_reasons = each.value.address_auto_suppress_reason_list
}

resource "aws_sesv2_account_vdm_attributes" "this" {
  for_each = local.lx_map
  dashboard_attributes {
    engagement_metrics = each.value.dashboard_engagement_enabled ? "ENABLED" : "DISABLED"
  }
  guardian_attributes {
    optimized_shared_delivery = each.value.guardian_shared_delivery_enabled ? "ENABLED" : "DISABLED"
  }
  region      = var.std_map.aws_region_name
  vdm_enabled = each.value.vdm_enabled ? "ENABLED" : "DISABLED"
}
