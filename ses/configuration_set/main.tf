resource "aws_sesv2_configuration_set" "this_config" {
  for_each               = local.lx_map
  configuration_set_name = each.value.name_effective
  delivery_options {
    sending_pool_name = each.value.ip_pool_name
    tls_policy        = each.value.tls_required ? "REQUIRE" : "OPTIONAL"
  }
  reputation_options {
    reputation_metrics_enabled = each.value.reputation_metrics_enabled
  }
  sending_options {
    sending_enabled = each.value.sending_enabled
  }
  suppression_options {
    suppressed_reasons = each.value.auto_suppress_address_reason_list
  }
  tags = each.value.tags
  dynamic "tracking_options" {
    for_each = each.value.tracking_custom_redirect_domain == null ? {} : { this = {} }
    content {
      custom_redirect_domain = each.value.tracking_custom_redirect_domain
    }
  }
  vdm_options {
    dashboard_options {
      engagement_metrics = each.value.vdm_dashboard_engagement_metrics_enabled ? "ENABLED" : "DISABLED"
    }
    guardian_options {
      optimized_shared_delivery = each.value.vdm_guardian_optimized_shared_delivery_enabled ? "ENABLED" : "DISABLED"
    }
  }
}

resource "aws_sesv2_configuration_set_event_destination" "destination" {
  for_each               = local.create_destination_x_map
  configuration_set_name = each.value.configuration_set_name
  event_destination {
    cloud_watch_destination {
      dynamic "dimension_configuration" {
        for_each = each.value.dimension_map
        content {
          default_dimension_value = dimension_configuration.value.default_value
          dimension_name          = dimension_configuration.key
          dimension_value_source  = dimension_configuration.value.value_source
        }
      }
    }
    enabled = each.value.enabled
    # event_bridge_destination
    # kinesis_firehose_destination
    matching_event_types = each.value.matching_event_type_list
    # pinpoint_destination
    # sns_destination
  }
  event_destination_name = each.value.k_dest
  region                 = var.std_map.aws_region_name
}
