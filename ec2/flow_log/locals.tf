module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.log_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      destination_arn                                = v.destination_arn == null ? var.log_destination_arn_default : v.destination_arn
      destination_file_format                        = v.destination_file_format == null ? var.log_destination_file_format_default : v.destination_file_format
      destination_hive_compatible_partitions_enabled = v.destination_hive_compatible_partitions_enabled == null ? var.log_destination_hive_compatible_partitions_enabled_default : v.destination_hive_compatible_partitions_enabled
      destination_per_hour_partition_enabled         = v.destination_per_hour_partition_enabled == null ? var.log_destination_per_hour_partition_enabled_default : v.destination_per_hour_partition_enabled
      destination_type                               = v.destination_type == null ? var.log_destination_type_default : v.destination_type
      iam_role_arn_cloudwatch_logs                   = v.iam_role_arn_cloudwatch_logs == null ? var.log_iam_role_arn_cloudwatch_logs_default : v.iam_role_arn_cloudwatch_logs
      iam_role_arn_cross_account_delivery            = v.iam_role_arn_cross_account_delivery == null ? var.log_iam_role_arn_cross_account_delivery_default : v.iam_role_arn_cross_account_delivery
      log_format                                     = v.log_format == null ? var.log_format_default : v.log_format
      max_aggregation_interval_seconds               = v.max_aggregation_interval_seconds == null ? var.log_max_aggregation_interval_seconds_default : v.max_aggregation_interval_seconds
      source_type                                    = v.source_type == null ? var.log_source_type_default : v.source_type
      traffic_type                                   = v.traffic_type == null ? var.log_traffic_type_default : v.traffic_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      eni_id                           = local.l1_map[k].source_type == "eni" ? v.source_id : null
      max_aggregation_interval_seconds = startswith(local.l1_map[k].source_type, "transit-gateway") ? 60 : local.l1_map[k].max_aggregation_interval_seconds
      subnet_id                        = local.l1_map[k].source_type == "subnet" ? v.source_id : null
      transit_gateway_attachment_id    = local.l1_map[k].source_type == "transit-gateway-attachment" ? v.source_id : null
      transit_gateway_id               = local.l1_map[k].source_type == "transit-gateway" ? v.source_id : null
      vpc_id                           = local.l1_map[k].source_type == "vpc" ? v.source_id : null
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      }
    )
  }
}
