resource "aws_flow_log" "this_log" {
  for_each                   = local.lx_map
  deliver_cross_account_role = each.value.iam_role_arn_cross_account_delivery
  destination_options {
    file_format                = each.value.destination_file_format
    hive_compatible_partitions = each.value.destination_hive_compatible_partitions_enabled
    per_hour_partition         = each.value.destination_per_hour_partition_enabled
  }
  eni_id               = each.value.eni_id
  iam_role_arn         = each.value.iam_role_arn_cloudwatch_logs
  log_destination      = each.value.destination_arn
  log_destination_type = each.value.destination_type
  # log_group_name # Obsolete, conflicts with log_destination
  log_format                    = each.value.log_format
  max_aggregation_interval      = each.value.max_aggregation_interval_seconds
  subnet_id                     = each.value.subnet_id
  tags                          = each.value.tags
  traffic_type                  = each.value.traffic_type
  transit_gateway_attachment_id = each.value.transit_gateway_attachment_id
  transit_gateway_id            = each.value.transit_gateway_id
  vpc_id                        = each.value.vpc_id
}
