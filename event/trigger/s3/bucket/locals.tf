module "name_map" {
  source                          = "../../../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prepend_default            = var.name_prepend_default
  std_map                         = var.std_map
}

locals {
  create_bus_map = {
    for k, v in local.lx_map : "${k}_prefix" => v if v.create_prefix
  }
  create_prefix_map = {
    for k, v in local.lx_map : "${k}_prefix" => merge(v, {
      event_pattern_json = jsonencode(module.s3_prefix_pattern["${k}_prefix"].data)
      role_policy_attach_arn_map = {
        events_write = module.event_bus.data["${k}_prefix"].bus.iam_policy_arn_map["write"]
      }
      target_arn     = module.event_bus.data["${k}_prefix"].bus.event_bus_arn
      target_service = "events"
    }) if v.create_prefix
  }
  create_suffix_map = {
    for k, v in local.lx_map : "${k}_suffix" => merge(v, {
      event_bus_name     = v.create_prefix ? module.event_bus.data["${k}_prefix"].bus.event_bus_name : null
      event_pattern_json = jsonencode(module.s3_suffix_pattern[k].data)
    })
  }
  l0_map = {
    for k, v in var.event_map : k => merge(v, {

    })
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      s3_bucket_name            = v.s3_bucket_name == null ? var.event_s3_bucket_name_default : v.s3_bucket_name
      s3_object_key_prefix_list = v.s3_object_key_prefix_list == null ? var.event_s3_object_key_prefix_list_default : v.s3_object_key_prefix_list
      s3_object_key_suffix_list = v.s3_object_key_suffix_list == null ? var.event_s3_object_key_suffix_list_default : v.s3_object_key_suffix_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      create_prefix = length(local.l1_map[k].s3_object_key_prefix_list) > 0
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
        bus            = v.create_prefix ? module.event_bus.data["${k}_prefix"] : null
        trigger_prefix = v.create_prefix ? module.trigger_prefix.data["${k}_prefix"] : null
        trigger_suffix = module.trigger_suffix.data["${k}_suffix"]
      }
    )
  }
}
