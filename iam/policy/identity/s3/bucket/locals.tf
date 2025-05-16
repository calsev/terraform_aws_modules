locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_policy_json = data.aws_iam_policy_document.this_policy_doc[k].json
    })
  }
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      access_set = toset([for _, v in v.sid_map : v.access])
      assert_map = {
        for k, v in v.sid_map : k => {
          bucket_name_list_assert = [
            for bucket_name in v.bucket_name_list : (startswith(bucket_name, "s3://") ? file("Bucket name should not be a URI") : null)
          ]
        }
      }
      sid_list_single = [
        for k_sid, v_sid in v.sid_map : merge(v_sid, {
          bucket_arn_list = [for bucket_name in v_sid.bucket_name_list : (startswith(bucket_name, "arn:") ? bucket_name : "arn:${var.std_map.iam_partition}:s3:::${bucket_name}")]
          object_key_list = v_sid.object_key_list == null ? var.sid_object_key_list_default : v_sid.object_key_list
          sid             = k_sid
        })
      ]
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      sid_list_expanded = flatten([
        for v_sid in local.l1_map[k].sid_list_single : [
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
      star_sid_list = [
        for access in local.l1_map[k].access_set : {
          action_list = var.std_map.service_resource_access_action.s3.star[access]
          sid         = "Star${var.std_map.access_title_map[access]}"
        } if length(var.std_map.service_resource_access_action.s3.star[access]) > 0
      ]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      sid_map = {
        for v_sid in local.l2_map[k].sid_list_expanded : v_sid.sid => v_sid
      }
      star_sid_map = {
        for v in local.l2_map[k].star_sid_list : v.sid => v
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["assert_map"], k_attr)
      },
      module.this_policy.data[k],
      {
      }
    )
  }
}
