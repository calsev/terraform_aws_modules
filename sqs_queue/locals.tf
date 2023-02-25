locals {
  fifo_map = {
    for k, v in var.queue_map : k => v.is_fifo == null ? var.queue_is_fifo_default : v.is_fifo
  }
  iam_policy_json_map = {
    for k, v in var.queue_map : k => v.iam_policy_json == null ? var.queue_iam_policy_json_default : v.iam_policy_json
  }
  queue_map = {
    for k, v in var.queue_map : k => merge(v, {
      content_based_deduplication       = local.fifo_map[k] ? v.content_based_deduplication == null ? var.queue_content_based_deduplication_default : v.content_based_deduplication : null
      deduplication_scope               = local.fifo_map[k] ? v.deduplication_scope == null ? var.queue_deduplication_scope_default : v.deduplication_scope : null
      delay_seconds                     = v.delay_seconds == null ? var.queue_delay_seconds_default : v.delay_seconds
      fifo_throughput_limit_type        = local.fifo_map[k] ? v.fifo_throughput_limit_type == null ? var.queue_fifo_throughput_limit_type_default : v.fifo_throughput_limit_type : null
      iam_policy                        = local.iam_policy_json_map[k] == null ? null : jsondecode(local.iam_policy_json_map[k])
      is_fifo                           = local.fifo_map[k]
      kms_data_key_reuse_period_minutes = v.kms_data_key_reuse_period_minutes == null ? var.queue_kms_data_key_reuse_period_minutes_default : v.kms_data_key_reuse_period_minutes
      kms_master_key_id                 = v.kms_master_key_id == null ? var.queue_kms_master_key_id_default : v.kms_master_key_id
      max_message_size_kib              = v.max_message_size_kib == null ? var.queue_max_message_size_kib_default : v.max_message_size_kib
      message_retention_hours           = v.message_retention_hours == null ? var.queue_message_retention_hours_default : v.message_retention_hours
      name                              = local.name_map[k]
      receive_wait_time_seconds         = v.receive_wait_time_seconds == null ? var.queue_receive_wait_time_seconds_default : v.receive_wait_time_seconds
      redrive_allow_policy              = local.redrive_allow_json_map[k] == null ? null : jsondecode(local.redrive_allow_json_map[k])
      redrive_policy                    = local.redrive_json_map[k] == null ? null : jsondecode(local.redrive_json_map[k])
      sqs_managed_sse_enabled           = v.sqs_managed_sse_enabled == null ? var.queue_sqs_managed_sse_enabled_default : v.sqs_managed_sse_enabled
      tags = merge(var.std_map.tags, {
        Name = local.name_map[k]
      })
      visibility_timeout_seconds = v.visibility_timeout_seconds == null ? var.queue_visibility_timeout_seconds_default : v.visibility_timeout_seconds
    })
  }
  name_map = {
    for k, v in var.queue_map : k => local.fifo_map[k] ? "${local.name_map_raw[k]}.fifo" : local.name_map_raw[k]
  }
  name_map_raw = {
    for k, v in var.queue_map : k => "${var.std_map.resource_name_prefix}${replace(k, "/[._]/", "-")}${var.std_map.resource_name_suffix}"
  }
  output_data = {
    for k, v in local.queue_map : k => merge(v, {
      arn = aws_sqs_queue.this_queue[k].arn
    })
  }
  redrive_allow_json_map = {
    for k, v in var.queue_map : k => v.redrive_allow_policy_json == null ? var.queue_redrive_allow_policy_json_default : v.redrive_allow_policy_json
  }
  redrive_json_map = {
    for k, v in var.queue_map : k => v.redrive_policy_json == null ? var.queue_redrive_policy_json_default : v.redrive_policy_json
  }
}
