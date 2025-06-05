module "name_map" {
  source                          = "../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_access_point_1_list = flatten([
    for k, v in local.lx_map : [
      for k_ap, v_ap in v.access_point_map : merge(v, v_ap)
    ]
  ])
  create_access_point_x_map = {
    for v in local.create_access_point_1_list : v.k_fs_ap => v
  }
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      efs_arn = aws_efs_file_system.this_fs[k].arn
    })
  }
  create_subnet_1_list = flatten([
    for k, v in local.lx_map : flatten([
      for k_sub, id_sub in v.vpc_subnet_id_map : merge(v, {
        k_sub     = k_sub
        subnet_id = id_sub
      })
    ])
  ])
  create_subnet_x_map = {
    for v in local.create_subnet_1_list : "${v.k_fs}-${v.k_sub}" => v
  }
  l0_map = {
    for k, v in var.fs_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      access_point_map    = v.access_point_map == null ? var.fs_access_point_map_default : v.access_point_map
      encrypt_file_system = v.encrypt_file_system == null ? var.fs_encrypt_file_system_default : v.encrypt_file_system
      k_fs                = k
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
      module.this_policy.data[k],
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
      }
    )
  }
}
