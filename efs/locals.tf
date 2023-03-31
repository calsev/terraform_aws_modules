module "name_map" {
  source   = "../name_map"
  name_map = var.fs_map
  std_map  = var.std_map
}

locals {
  fs_map = {
    for k, v in var.fs_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l1_map = {
    for k, v in var.fs_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      create_policies     = v.create_policies == null ? var.fs_create_policies_default : v.create_policies
      encrypt_file_system = v.encrypt_file_system == null ? var.fs_encrypt_file_system_default : v.encrypt_file_system
      k_fs                = k
    })
  }
  l2_map = {
    for k, v in var.fs_map : k => merge(module.vpc_map.data[k], {
      policy_name = local.l1_map[k].create_policies ? "efs-${local.l1_map[k].name_simple}" : null
    })
  }
  output_data = {
    for k, v in local.fs_map : k => merge(
      v.create_policies ? module.this_policy[k].data : null,
      {
        efs_arn            = aws_efs_file_system.this_fs[k].arn
        efs_dns_name       = aws_efs_file_system.this_fs[k].dns_name
        efs_id             = aws_efs_file_system.this_fs[k].id
        iam_policy_doc_efs = jsondecode(data.aws_iam_policy_document.this_policy_doc[k].json)
      },
    )
  }
  policy_map = {
    for k, v in local.fs_map : k => v if v.create_policies
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
