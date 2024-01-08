module "group_name_map" {
  source             = "../../name_map"
  name_infix_default = var.group_name_infix_default
  name_map           = var.group_map
  std_map            = var.std_map
}

module "user_name_map" {
  source             = "../../name_map"
  name_infix_default = var.user_name_infix_default
  name_map           = var.user_map
  std_map            = var.std_map
}

module "group_policy_map" {
  source     = "../../iam/policy_map"
  policy_map = var.group_map
  std_map    = var.std_map
}

module "user_policy_map" {
  source     = "../../iam/policy_map"
  policy_map = var.user_map
  std_map    = var.std_map
}

locals {
  g1_map = {
    for k, v in var.group_map : k => merge(v, module.group_name_map.data[k], module.group_policy_map.policy_map[k], {
      k_user_list = v.k_user_list == null ? var.group_k_user_list_default : v.k_user_list
      path        = v.path == null ? var.group_path_default : v.path
    })
  }
  group_map = {
    for k, v in var.group_map : k => merge(local.g1_map[k])
  }
  u1_map = {
    for k, v in var.user_map : k => merge(v, module.user_name_map.data[k], module.user_policy_map.policy_map[k], {
      create_access_key     = v.create_access_key == null ? var.user_create_access_key_default : v.create_access_key
      enable_console_access = v.enable_console_access == null ? var.user_enable_console_access_default : v.enable_console_access
      force_destroy         = v.force_destroy == null ? var.user_force_destroy_default : v.force_destroy
      path                  = v.path == null ? var.user_path_default : v.path
      pgp_key               = v.pgp_key == null ? var.user_pgp_key_default : v.pgp_key
    })
  }
  user_console_map = {
    for k, v in local.user_map : k => v if v.enable_console_access
  }
  user_key_map = {
    for k, v in local.user_map : k => v if v.create_access_key
  }
  user_map = {
    for k, v in var.user_map : k => merge(local.u1_map[k])
  }
  output_data = {
    group = {
      for k, v in local.group_map : k => merge(v, {
        arn = aws_iam_group.this_group[k].arn
      })
    }
    user = {
      for k, v in local.user_map : k => merge(
        {
          for k_user, v_user in v : k_user => v_user if !contains(["policy_inline_json_map"], k_user)
        },
        {
          arn = aws_iam_user.this_user[k].arn
        },
      )
    }
  }
}
