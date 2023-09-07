resource "aws_sqs_queue" "this_queue" {
  for_each                          = local.create_queue_map
  content_based_deduplication       = each.value.content_based_deduplication
  deduplication_scope               = each.value.deduplication_scope
  delay_seconds                     = each.value.delay_seconds
  fifo_queue                        = each.value.is_fifo
  fifo_throughput_limit             = each.value.fifo_throughput_limit_type
  kms_data_key_reuse_period_seconds = each.value.kms_data_key_reuse_period_minutes == null ? null : each.value.kms_data_key_reuse_period_minutes * 60
  kms_master_key_id                 = each.value.kms_master_key_id
  max_message_size                  = each.value.max_message_size_kib * 1024
  message_retention_seconds         = each.value.message_retention_hours * 60 * 60
  name                              = each.value.name_effective
  policy                            = each.value.iam_policy == null ? null : jsonencode(each.value.iam_policy)
  receive_wait_time_seconds         = each.value.receive_wait_time_seconds
  redrive_allow_policy              = each.value.redrive_allow_policy == null ? null : jsonencode(each.value.redrive_allow_policy)
  redrive_policy                    = each.value.redrive_policy == null ? null : jsonencode(each.value.redrive_policy)
  sqs_managed_sse_enabled           = each.value.sqs_managed_sse_enabled
  tags                              = each.value.tags
  visibility_timeout_seconds        = each.value.visibility_timeout_seconds
}
