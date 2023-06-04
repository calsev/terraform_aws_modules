locals {
  bus_map = {
    for k, v in var.event_map : "${k}_prefix" => {}
  }
  l1_map = {
    for k, v in var.event_map : k => {
      s3_bucket_name            = v.s3_bucket_name == null ? var.event_s3_bucket_name_default : v.s3_bucket_name
      s3_object_key_prefix_list = v.s3_object_key_prefix_list == null ? var.event_s3_object_key_prefix_list_default : v.s3_object_key_prefix_list
      s3_object_key_suffix_list = v.s3_object_key_suffix_list == null ? var.event_s3_object_key_suffix_list_default : v.s3_object_key_suffix_list
    }
  }
  event_map = {
    for k, v in var.event_map : k => merge(v, local.l1_map[k])
  }
  output_data = {
    bus = module.event_bus.data
    trigger = merge(
      module.trigger_prefix.data,
      module.trigger_suffix.data,
    )
  }
  trigger_prefix_map = {
    for k, v in local.event_map : "${k}_prefix" => merge(local.l1_map[k], {
      event_pattern_json    = jsonencode(module.s3_prefix_pattern[k].data)
      iam_policy_arn_target = module.event_bus.data["${k}_prefix"].bus.iam_policy_arn_map["write"]
      target_arn            = module.event_bus.data["${k}_prefix"].bus.event_bus_arn
      target_service        = "events"
    })
  }
  trigger_suffix_map = {
    for k, v in local.event_map : "${k}_suffix" => merge(v, {
      event_bus_name     = module.event_bus.data["${k}_prefix"].bus.event_bus_name
      event_pattern_json = jsonencode(module.s3_suffix_pattern[k].data)
    })
  }
}
