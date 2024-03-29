locals {
  sns_topic_arn = "arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:${var.sns_topic_name}"
  service_name  = "sns"
  sid_list_expanded = flatten([
    for v_sid in local.sid_list_single : [
      merge(v_sid, {
        resource_type = "topic"
        resource_list = [local.sns_topic_arn]
        sid           = "${v_sid.sid}Topic${var.std_map.access_title_map[v_sid.access]}"
      }),
    ]
  ])
  sid_list_single = [
    for k_sid, v_sid in var.sid_map : merge(v_sid, {
      condition_map   = v_sid.condition_map == null ? {} : v_sid.condition_map
      identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
      identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
      sid             = k_sid
    })
  ]
  sid_map = {
    for v_sid in local.sid_list_expanded : v_sid.sid => v_sid
  }
}
