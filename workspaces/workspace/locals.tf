module "name_map" {
  source                          = "../../name_map"
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

locals {
  create_bundle_data_map = {
    for k, v in local.lx_map : k => v if v.bundle_id == null
  }
  create_workspace_map = {
    for k, v in local.lx_map : k => merge(v, {
      bundle_id = v.bundle_id == null ? data.aws_workspaces_bundle.this_bundle[k].id : v.bundle_id
    })
  }
  l0_map = {
    for k, v in var.workspace_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      bundle_id                              = v.bundle_id == null ? var.workspace_bundle_id_default : v.bundle_id
      bundle_name                            = v.bundle_name == null ? var.workspace_bundle_name_default : v.bundle_name
      bundle_owner                           = v.bundle_owner == null ? var.workspace_bundle_owner_default : v.bundle_owner
      compute_type_name                      = v.compute_type_name == null ? var.workspace_compute_type_name_default : v.compute_type_name
      directory_key                          = v.directory_key == null ? var.workspace_directory_key_default : v.directory_key
      kms_key_id_volume_encryption           = v.kms_key_id_volume_encryption == null ? var.workspace_kms_key_id_volume_encryption_default == null ? data.aws_kms_key.workspaces.id : var.workspace_kms_key_id_volume_encryption_default : v.kms_key_id_volume_encryption
      root_volume_encryption_enabled         = v.root_volume_encryption_enabled == null ? var.workspace_root_volume_encryption_enabled_default : v.root_volume_encryption_enabled
      root_volume_size_gib                   = v.root_volume_size_gib == null ? var.workspace_root_volume_size_gib_default : v.root_volume_size_gib
      running_mode                           = v.running_mode == null ? var.workspace_running_mode_default : v.running_mode
      running_mode_auto_stop_timeout_minutes = v.running_mode_auto_stop_timeout_minutes == null ? var.workspace_running_mode_auto_stop_timeout_minutes_default : v.running_mode_auto_stop_timeout_minutes
      user_name                              = v.user_name == null ? var.workspace_user_name_default == null ? k : var.workspace_user_name_default : v.user_name
      user_volume_encryption_enabled         = v.user_volume_encryption_enabled == null ? var.workspace_user_volume_encryption_enabled_default : v.user_volume_encryption_enabled
      user_volume_size_gib                   = v.user_volume_size_gib == null ? var.workspace_user_volume_size_gib_default : v.user_volume_size_gib
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      directory_id = var.workspace_directory_data_map[local.l1_map[k].directory_key].directory_id
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.create_workspace_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        workspace_computer_name = aws_workspaces_workspace.this_workspace[k].computer_name
        workspace_id            = aws_workspaces_workspace.this_workspace[k].id
        workspace_ip_address    = aws_workspaces_workspace.this_workspace[k].ip_address
      }
    )
  }
}
