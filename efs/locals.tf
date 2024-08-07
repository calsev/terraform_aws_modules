module "name_map" {
  source   = "../name_map"
  name_map = var.fs_map
  std_map  = var.std_map
}

module "policy_map" {
  source                      = "../iam/policy/name_map"
  name_map                    = var.fs_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  access_point_flattened_list = flatten([
    for k, v in local.fs_map : [
      for k_ap, v_ap in v.access_point_map : merge(v, v_ap)
    ]
  ])
  access_point_flattened_map = {
    for v in local.access_point_flattened_list : v.k_fs_ap => v
  }
  fs_map = {
    for k, v in var.fs_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l1_map = {
    for k, v in var.fs_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], module.vpc_map.data[k], {
      access_point_map    = v.access_point_map == null ? var.fs_access_point_map_default : v.access_point_map
      encrypt_file_system = v.encrypt_file_system == null ? var.fs_encrypt_file_system_default : v.encrypt_file_system
      k_fs                = k
    })
  }
  l2_map = {
    for k, v in var.fs_map : k => merge(module.vpc_map.data[k], {
      access_point_map = {
        for k_ap, v_ap in local.l1_map[k].access_point_map : k_ap => merge(v_ap, {
          k_fs_ap                 = "${k}-${k_ap}"
          k_fs                    = k
          owner_gid               = v_ap.owner_gid == null ? var.fs_access_point_owner_gid_default : v_ap.owner_gid
          owner_uid               = v_ap.owner_uid == null ? var.fs_access_point_owner_uid_default : v_ap.owner_uid
          path                    = v_ap.path == null ? k_ap : v_ap.path
          permission_mode         = v_ap.permission_mode == null ? var.fs_access_point_permission_mode_default : v_ap.permission_mode
          user_gid                = v_ap.user_gid == null ? var.fs_access_point_user_gid_default : v_ap.user_gid
          user_gid_secondary_list = v_ap.user_gid_secondary_list == null ? var.fs_access_point_user_gid_secondary_list_default : v_ap.user_gid_secondary_list
          user_uid                = v_ap.user_uid == null ? var.fs_access_point_user_uid_default : v_ap.user_uid
        })
      }
    })
  }
  output_data = {
    for k, v in local.fs_map : k => merge(
      v,
      module.this_policy[k].data,
      {
        access_point_map = {
          for k_ap, v_ap in v.access_point_map : k_ap => merge(v_ap, {
            access_point_id = aws_efs_access_point.this_access_point[v_ap.k_fs_ap].id
          })
        }
        efs_arn            = aws_efs_file_system.this_fs[k].arn
        efs_dns_name       = aws_efs_file_system.this_fs[k].dns_name
        efs_id             = aws_efs_file_system.this_fs[k].id
        iam_policy_doc_efs = jsondecode(data.aws_iam_policy_document.this_policy_doc[k].json)
      },
    )
  }
  subnet_flattened_list = flatten([
    for k, v in local.fs_map : flatten([
      for k_sub, id_sub in v.vpc_subnet_id_map : merge(v, {
        k_sub     = k_sub
        subnet_id = id_sub
      })
    ])
  ])
  subnet_flattened_map = {
    for v in local.subnet_flattened_list : "${v.k_fs}-${v.k_sub}" => v
  }
}
