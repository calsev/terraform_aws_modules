locals {
  bucket_arn   = "arn:${var.std_map.iam_partition}:${local.service_name}:::${var.bucket_name}"
  has_policy   = length(local.sid_list_single) != 0
  policy_json  = local.has_policy ? data.aws_iam_policy_document.policy_doc["this"].json : data.aws_iam_policy_document.empty_policy["this"].json
  service_name = "s3"
  sid_list_expanded = flatten([
    for v_sid in local.sid_list_single : [
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
  sid_list_single_var = [
    for k_sid, v_sid in var.sid_map : merge(v_sid, {
      condition_map   = v_sid.condition_map == null ? {} : v_sid.condition_map
      identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
      identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
      object_key_list = v_sid.object_key_list == null ? var.sid_object_key_list_default : v_sid.object_key_list
      sid             = k_sid
    })
  ]
  sid_list_single = !var.allow_public ? local.sid_list_single_var : concat(local.sid_list_single_var, [
    {
      access          = "public_read"
      condition_map   = {}
      identifier_list = ["*"]
      identifier_type = "*"
      object_key_list = ["*"]
      sid             = "World"
    }
  ])
  sid_map = {
    for v_sid in local.sid_list_expanded : v_sid.sid => v_sid
  }
}
