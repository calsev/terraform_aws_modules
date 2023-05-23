locals {
  access_set = toset([for _, v in var.sid_map : v.access])
  # tflint-ignore: terraform_unused_declarations
  assert_map = {
    for k, v in var.sid_map : k => {
      bucket_name_list_assert = [
        for bucket_name in v.bucket_name_list : (startswith(bucket_name, "s3://") ? file("Bucket name should not be a URI") : null)
      ]
    }
  }
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
  star_sid_list = [
    for access in local.access_set : {
      action_list = var.std_map.service_resource_access_action.s3.star[access]
      sid         = "Star${var.std_map.access_title_map[access]}"
    } if length(var.std_map.service_resource_access_action.s3.star[access]) > 0
  ]
  star_sid_map = {
    for v in local.star_sid_list : v.sid => v
  }
}
