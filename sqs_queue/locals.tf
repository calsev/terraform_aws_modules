module "name_map" {
  source = "../name_map"
  name_map = {
    for k, v in local.l0_map : k => merge(v, {
      name_suffix = v.is_fifo ? ".fifo" : null
    })
  }
  std_map = var.std_map
}

module "policy_map" {
  source                      = "../policy_name_map"
  name_map                    = var.queue_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  create_queue_map = {
    for k, v in local.queue_map : k => v if v.create_queue
  }
  l0_map = {
    for k, v in var.queue_map : k => merge(v, {
      is_fifo = v.is_fifo == null ? var.queue_is_fifo_default : v.is_fifo
    })
  }
  l1_map = {
    for k, v in var.queue_map : k => merge(local.l0_map[k], module.name_map.data[k], module.policy_map.data[k], {
      create_queue                      = v.create_queue == null ? var.queue_create_queue_default : v.create_queue
      delay_seconds                     = v.delay_seconds == null ? var.queue_delay_seconds_default : v.delay_seconds
      iam_policy_json                   = v.iam_policy_json == null ? var.queue_iam_policy_json_default : v.iam_policy_json
      kms_data_key_reuse_period_minutes = v.kms_data_key_reuse_period_minutes == null ? var.queue_kms_data_key_reuse_period_minutes_default : v.kms_data_key_reuse_period_minutes
      kms_master_key_id                 = v.kms_master_key_id == null ? var.queue_kms_master_key_id_default : v.kms_master_key_id
      max_message_size_kib              = v.max_message_size_kib == null ? var.queue_max_message_size_kib_default : v.max_message_size_kib
      message_retention_hours           = v.message_retention_hours == null ? var.queue_message_retention_hours_default : v.message_retention_hours
      receive_wait_time_seconds         = v.receive_wait_time_seconds == null ? var.queue_receive_wait_time_seconds_default : v.receive_wait_time_seconds
      redrive_allow_policy_json         = v.redrive_allow_policy_json == null ? var.queue_redrive_allow_policy_json_default : v.redrive_allow_policy_json
      redrive_policy_json               = v.redrive_policy_json == null ? var.queue_redrive_policy_json_default : v.redrive_policy_json
      sqs_managed_sse_enabled           = v.sqs_managed_sse_enabled == null ? var.queue_sqs_managed_sse_enabled_default : v.sqs_managed_sse_enabled
      visibility_timeout_seconds        = v.visibility_timeout_seconds == null ? var.queue_visibility_timeout_seconds_default : v.visibility_timeout_seconds
    })
  }
  l2_map = {
    for k, v in var.queue_map : k => {
      content_based_deduplication = local.l1_map[k].is_fifo ? v.content_based_deduplication == null ? var.queue_content_based_deduplication_default : v.content_based_deduplication : null
      deduplication_scope         = local.l1_map[k].is_fifo ? v.deduplication_scope == null ? var.queue_deduplication_scope_default : v.deduplication_scope : null
      fifo_throughput_limit_type  = local.l1_map[k].is_fifo ? v.fifo_throughput_limit_type == null ? var.queue_fifo_throughput_limit_type_default : v.fifo_throughput_limit_type : null
      iam_policy                  = local.l1_map[k].iam_policy_json == null ? null : jsondecode(local.l1_map[k].iam_policy_json)
      redrive_allow_policy        = local.l1_map[k].redrive_allow_policy_json == null ? null : jsondecode(local.l1_map[k].redrive_allow_policy_json)
      redrive_policy              = local.l1_map[k].redrive_policy_json == null ? null : jsondecode(local.l1_map[k].redrive_policy_json)
    }
  }
  output_data = {
    for k, v in local.queue_map : k => merge(
      v,
      module.queue_policy[k].data,
      {
        arn = v.create_queue ? aws_sqs_queue.this_queue[k].arn : null
        url = v.create_queue ? aws_sqs_queue.this_queue[k].url : null
      },
    )
  }
  queue_map = {
    for k, v in var.queue_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
