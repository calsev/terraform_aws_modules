locals {
  bus_arn           = startswith(var.bus_name, "arn:") ? var.bus_name : "arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:event-bus/${var.bus_name}"
  final_policy_json = data.aws_iam_policy_document.final_policy.json
  has_custom_policy = length(local.sid_map) != 0
  has_empty_policy  = !local.has_custom_policy
  service_name      = "events"
  sid_list_1_expanded = [
    for k_sid, v_sid in var.sid_map == null ? {} : var.sid_map : merge(v_sid, {
      condition_map   = v_sid.condition_map == null ? var.sid_condition_map_default : v_sid.condition_map
      identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
      identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
      sid             = k_sid
    })
  ]
  sid_list_2_single = flatten([
    for v_sid in local.sid_list_1_expanded : [
      merge(v_sid, {
        resource_type = "event-bus"
        resource_list = [local.bus_arn]
        sid           = "${v_sid.sid}Bus${var.std_map.access_title_map[v_sid.access]}"
      }),
    ]
  ])
  sid_map = {
    for v_sid in local.sid_list_2_single : v_sid.sid => v_sid
  }
}
