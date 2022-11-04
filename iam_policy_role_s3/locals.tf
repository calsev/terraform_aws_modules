locals {
  sid_list_expanded = flatten([
    for v_sid in local.sid_list_single : [
      merge(v_sid, {
        resource_type = "bucket"
        resource_list = v_sid.bucket_arn_list
        sid           = "${v_sid.sid}Bucket${var.std_map.access_title_map[v_sid.access]}"
      }),
      merge(v_sid, {
        resource_type = "object"
        resource_list = flatten([for bucket_arn in v_sid.bucket_arn_list : [for object_key in v_sid.object_key_list : "${bucket_arn}/${object_key}"]])
        sid           = "${v_sid.sid}Object${var.std_map.access_title_map[v_sid.access]}"
      }),
      merge(v_sid, {
        resource_type = "star"
        resource_list = ["*"]
        sid           = "${v_sid.sid}All${var.std_map.access_title_map[v_sid.access]}"
      }),
    ]
  ])
  sid_list_single = [
    for k_sid, v_sid in var.sid_map : merge(v_sid, {
      bucket_arn_list = [for bucket_name in v_sid.bucket_name_list : "arn:${var.std_map.iam_partition}:s3:::${bucket_name}"]
      object_key_list = v_sid.object_key_list == null ? var.sid_object_key_list_default : v_sid.object_key_list
      sid             = k_sid
    })
  ]
  sid_map = {
    for v_sid in local.sid_list_expanded : v_sid.sid => v_sid
  }
}
