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

module "vpc_map" {
  source                  = "../../vpc/id_map"
  vpc_map                 = local.l0_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  vpc_segment_key_default = var.vpc_segment_key_default
  vpc_data_map            = var.vpc_data_map
}

locals {
  l0_map = {
    for k, v in var.directory_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      ip_group_id_list                                    = v.ip_group_id_list == null ? var.directory_ip_group_id_list_default : v.ip_group_id_list
      self_service_change_compute_type_allowed            = v.self_service_change_compute_type_allowed == null ? var.directory_self_service_change_compute_type_allowed_default : v.self_service_change_compute_type_allowed
      self_service_increase_volume_size_allowed           = v.self_service_increase_volume_size_allowed == null ? var.directory_self_service_increase_volume_size_allowed_default : v.self_service_increase_volume_size_allowed
      self_service_rebuild_workspace_allowed              = v.self_service_rebuild_workspace_allowed == null ? var.directory_self_service_rebuild_workspace_allowed_default : v.self_service_rebuild_workspace_allowed
      self_service_restart_workspace_allowed_allowed      = v.self_service_restart_workspace_allowed_allowed == null ? var.directory_self_service_restart_workspace_allowed_allowed_default : v.self_service_restart_workspace_allowed_allowed
      self_service_switch_running_mode_allowed            = v.self_service_switch_running_mode_allowed == null ? var.directory_self_service_switch_running_mode_allowed_default : v.self_service_switch_running_mode_allowed
      service_directory_key                               = v.service_directory_key == null ? var.directory_service_directory_key_default : v.service_directory_key
      workspace_access_from_android_allowed               = v.workspace_access_from_android_allowed == null ? var.directory_workspace_access_from_android_allowed_default : v.workspace_access_from_android_allowed
      workspace_access_from_chrome_os_allowed             = v.workspace_access_from_chrome_os_allowed == null ? var.directory_workspace_access_from_chrome_os_allowed_default : v.workspace_access_from_chrome_os_allowed
      workspace_access_from_ios_allowed                   = v.workspace_access_from_ios_allowed == null ? var.directory_workspace_access_from_ios_allowed_default : v.workspace_access_from_ios_allowed
      workspace_access_from_linux_allowed                 = v.workspace_access_from_linux_allowed == null ? var.directory_workspace_access_from_linux_allowed_default : v.workspace_access_from_linux_allowed
      workspace_access_from_osx_allowed                   = v.workspace_access_from_osx_allowed == null ? var.directory_workspace_access_from_osx_allowed_default : v.workspace_access_from_osx_allowed
      workspace_access_from_web_allowed                   = v.workspace_access_from_web_allowed == null ? var.directory_workspace_access_from_web_allowed_default : v.workspace_access_from_web_allowed
      workspace_access_from_windows_allowed               = v.workspace_access_from_windows_allowed == null ? var.directory_workspace_access_from_windows_allowed_default : v.workspace_access_from_windows_allowed
      workspace_access_from_zero_client_allowed           = v.workspace_access_from_zero_client_allowed == null ? var.directory_workspace_access_from_zero_client_allowed_default : v.workspace_access_from_zero_client_allowed
      workspace_creation_internet_access_enabled          = v.workspace_creation_internet_access_enabled == null ? var.directory_workspace_creation_internet_access_enabled_default : v.workspace_creation_internet_access_enabled
      workspace_creation_maintenance_mode_enabled         = v.workspace_creation_maintenance_mode_enabled == null ? var.directory_workspace_creation_maintenance_mode_enabled_default : v.workspace_creation_maintenance_mode_enabled
      workspace_creation_ou                               = v.workspace_creation_ou == null ? var.directory_workspace_creation_ou_root_default == null ? null : "OU=${k},${var.directory_workspace_creation_ou_root_default}" : v.workspace_creation_ou
      workspace_creation_user_local_administrator_enabled = v.workspace_creation_user_local_administrator_enabled == null ? var.directory_workspace_creation_user_local_administrator_enabled_default : v.workspace_creation_user_local_administrator_enabled
      workspace_creation_vpc_security_group_id_custom     = v.workspace_creation_vpc_security_group_id_custom == null ? var.directory_workspace_creation_vpc_security_group_id_custom_default : v.workspace_creation_vpc_security_group_id_custom
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      service_directory_id = var.service_directory_data_map[local.l1_map[k].service_directory_key].directory_id
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
      {
        directory_id                = aws_workspaces_directory.this_dir[k].id
        directory_dns_ip_addresses  = aws_workspaces_directory.this_dir[k].dns_ip_addresses
        directory_registration_code = aws_workspaces_directory.this_dir[k].registration_code
      }
    )
  }
}
