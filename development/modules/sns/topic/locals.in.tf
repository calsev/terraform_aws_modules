module "subscription_name_map" {
  source   = "../../name_map"
  name_map = var.subscription_map
  std_map  = var.std_map
}

module "topic_name_map" {
  source   = "../../name_map"
  name_map = local.t2_map
  std_map  = var.std_map
}

locals {
  all_topic_list = sort([
    for k, _ in var.topic_map : k
  ])
  output_data = {
    subscription_map = {
      for k, v in local.subscription_map : k => merge(v, {
        subscription_arn_map = {
          for k_topic in v.k_topic_list : k_topic => aws_sns_topic_subscription.this_sub["${k_topic}-${k}"].arn
        }
      })
    }
    topic_map = {
      for k, v in local.topic_map : k => merge(v, {
        policy_doc = v.has_policy ? module.this_policy[k].iam_policy_doc : null
        topic_arn  = aws_sns_topic.this_topic[k].arn
      })
    }
  }
  s1_map = {
    for k, v in var.subscription_map : k => merge(v, module.subscription_name_map.data[k], {
      confirmation_timeout_min = v.confirmation_timeout_min == null ? var.subscription_confirmation_timeout_min_default : v.confirmation_timeout_min
      endpoint                 = v.endpoint == null ? k : v.endpoint
      endpoint_auto_confirms   = v.endpoint_auto_confirms == null ? var.subscription_endpoint_auto_confirms_default : v.endpoint_auto_confirms
      k_topic_list             = v.k_topic_list == null ? var.subscription_k_topic_list_default == null ? local.all_topic_list : var.subscription_k_topic_list_default : v.k_topic_list
      protocol                 = v.protocol == null ? var.subscription_protocol_default : v.protocol
      raw_message_delivery     = v.raw_message_delivery == null ? var.subscription_raw_message_delivery_default : v.raw_message_delivery
    })
  }
  source_account_condition = {
    test       = "StringEquals"
    value_list = [var.std_map.aws_account_id]
    variable   = "AWS:SourceAccount" # SourceOwner does not work
  }
  subscription_flattened_list = flatten([
    for k, v in local.subscription_map : [
      for k_topic in v.k_topic_list : merge(v, {
        k_topic              = k_topic
        k_topic_subscription = "${k_topic}-${k}"
      })
    ]
  ])
  subscription_flattened_map = {
    for v in local.subscription_flattened_list : v.k_topic_subscription => v
  }
  subscription_map = {
    for k, v in var.subscription_map : k => merge(local.s1_map[k])
  }
  t1_map = {
    for k, v in var.topic_map : k => merge(v, {
      allow_events = v.allow_events == null ? var.topic_allow_events_default : v.allow_events
      is_fifo      = v.is_fifo == null ? var.topic_is_fifo_default : v.is_fifo
    })
  }
  t2_map = {
    for k, v in var.topic_map : k => {
      has_policy  = local.t1_map[k].allow_events
      name_suffix = local.t1_map[k].is_fifo ? ".fifo" : ""
    }
  }
  t3_map = {
    for k, v in var.topic_map : k => merge(module.topic_name_map.data[k], {
      enable_content_based_deduplication = v.enable_content_based_deduplication == null ? var.topic_enable_content_based_deduplication_default : v.enable_content_based_deduplication
      kms_key                            = local.t1_map[k].allow_events ? null : v.kms_key == null ? var.topic_kms_key_default : v.kms_key
      signature_version                  = v.signature_version == null ? var.topic_signature_version_default : v.signature_version
    })
  }
  topic_map = {
    for k, v in var.topic_map : k => merge(local.t1_map[k], local.t2_map[k], local.t3_map[k])
  }
  topic_policy_map = {
    for k, v in local.topic_map : k => v if v.has_policy
  }
}
