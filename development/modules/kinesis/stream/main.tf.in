resource "aws_kinesis_stream" "this_stream" {
  for_each                  = local.lx_map
  encryption_type           = each.value.encryption_type
  enforce_consumer_deletion = each.value.enforce_consumer_deletion
  kms_key_id                = each.value.kms_key_id
  name                      = each.value.name_effective
  region                    = each.value.aws_region_name
  retention_period          = each.value.retention_period_h
  shard_count               = each.value.shard_count
  shard_level_metrics       = each.value.shard_level_metric_list
  stream_mode_details {
    stream_mode = each.value.stream_capacity_mode
  }
  tags = each.value.tags
}
