locals {
  bucket_arn             = startswith(var.bucket_name, "arn:") ? var.bucket_name : "arn:${var.std_map.iam_partition}:${local.service_name}:::${var.bucket_name}"
  cloud_trail_arn_prefix = "arn:${var.std_map.iam_partition}:cloudtrail:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:trail/*"
  final_policy_json      = data.aws_iam_policy_document.final_policy.json
  has_custom_policy      = length(local.sid_map) != 0
  has_empty_policy       = !var.allow_access_point && var.allow_insecure_access && !var.allow_service_logging && !local.has_custom_policy
  logs_arn_prefix        = "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:*"
  log_object_prefix      = "${local.bucket_arn}/*" # AWSLogs/${var.std_map.aws_account_id}/* prevents prefixes
  service_name           = "s3"
  sid_1_list_single_var = [
    for k_sid, v_sid in var.sid_map : merge(v_sid, {
      condition_map   = v_sid.condition_map == null ? {} : v_sid.condition_map
      identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
      identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
      object_key_list = v_sid.object_key_list == null ? var.sid_object_key_list_default : v_sid.object_key_list
      sid             = k_sid
    })
  ]
  sid_2_list_single = concat(
    local.sid_1_list_single_var,
    var.allow_public ? [
      {
        access          = "public_read"
        condition_map   = {}
        identifier_list = ["*"]
        identifier_type = "*"
        object_key_list = ["*"]
        sid             = "World"
      }
    ] : [],
  )
  sid_3_list_expanded = flatten([
    for v_sid in local.sid_2_list_single : [
      merge(v_sid, {
        resource_type = "bucket"
        resource_list = [local.bucket_arn]
        sid           = "${v_sid.sid}Bucket${var.std_map.access_title_map[v_sid.access]}"
      }),
      merge(v_sid, {
        resource_type = "object"
        resource_list = [for object_key in v_sid.object_key_list : "${local.bucket_arn}/${object_key}"]
        sid           = "${v_sid.sid}Object${var.std_map.access_title_map[v_sid.access]}"
      }),
    ]
  ])
  sid_map = {
    for v_sid in local.sid_3_list_expanded : v_sid.sid => v_sid
  }
}
