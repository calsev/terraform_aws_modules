resource "aws_sns_topic" "this_topic" {
  for_each                                 = local.topic_map
  application_failure_feedback_role_arn    = null # TODO
  application_success_feedback_role_arn    = null # TODO
  application_success_feedback_sample_rate = null # TODO
  content_based_deduplication              = each.value.enable_content_based_deduplication
  delivery_policy                          = null # TODO
  display_name                             = null # TODO
  fifo_topic                               = each.value.is_fifo
  firehose_failure_feedback_role_arn       = null # TODO
  firehose_success_feedback_role_arn       = null # TODO
  firehose_success_feedback_sample_rate    = null # TODO
  http_failure_feedback_role_arn           = null # TODO
  http_success_feedback_role_arn           = null # TODO
  http_success_feedback_sample_rate        = null # TODO
  kms_master_key_id                        = each.value.kms_key
  lambda_failure_feedback_role_arn         = null # TODO
  lambda_success_feedback_role_arn         = null # TODO
  lambda_success_feedback_sample_rate      = null # TODO
  name                                     = each.value.name_effective
  name_prefix                              = null
  policy                                   = each.value.has_policy ? jsonencode(module.this_policy[each.key].iam_policy_doc) : null
  signature_version                        = each.value.signature_version
  sqs_failure_feedback_role_arn            = null # TODO
  sqs_success_feedback_role_arn            = null # TODO
  sqs_success_feedback_sample_rate         = null # TODO
  tags                                     = each.value.tags
  tracing_config                           = null # TODO
}

resource "aws_sns_topic_subscription" "this_sub" {
  for_each                        = local.subscription_flattened_map
  confirmation_timeout_in_minutes = each.value.confirmation_timeout_min
  delivery_policy                 = null # TODO
  endpoint                        = each.value.endpoint
  endpoint_auto_confirms          = each.value.endpoint_auto_confirms
  filter_policy                   = null # TODO
  filter_policy_scope             = null # TODO
  protocol                        = each.value.protocol
  redrive_policy                  = null # TODO
  raw_message_delivery            = each.value.raw_message_delivery
  subscription_role_arn           = null # For firehose
  topic_arn                       = aws_sns_topic.this_topic[each.value.k_topic].arn
}
