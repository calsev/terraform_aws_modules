resource "aws_workspaces_directory" "this_dir" {
  for_each     = local.lx_map
  directory_id = each.value.service_directory_id
  ip_group_ids = each.value.ip_group_id_list
  self_service_permissions {
    change_compute_type  = each.value.self_service_change_compute_type_allowed
    increase_volume_size = each.value.self_service_increase_volume_size_allowed
    rebuild_workspace    = each.value.self_service_rebuild_workspace_allowed
    restart_workspace    = each.value.self_service_restart_workspace_allowed_allowed
    switch_running_mode  = each.value.self_service_switch_running_mode_allowed
  }
  subnet_ids = each.value.vpc_subnet_id_list
  tags       = each.value.tags
  workspace_access_properties {
    device_type_android    = each.value.workspace_access_from_android_allowed ? "ALLOW" : "DENY"
    device_type_chromeos   = each.value.workspace_access_from_chrome_os_allowed ? "ALLOW" : "DENY"
    device_type_ios        = each.value.workspace_access_from_ios_allowed ? "ALLOW" : "DENY"
    device_type_linux      = each.value.workspace_access_from_linux_allowed ? "ALLOW" : "DENY"
    device_type_osx        = each.value.workspace_access_from_osx_allowed ? "ALLOW" : "DENY"
    device_type_web        = each.value.workspace_access_from_web_allowed ? "ALLOW" : "DENY"
    device_type_windows    = each.value.workspace_access_from_windows_allowed ? "ALLOW" : "DENY"
    device_type_zeroclient = each.value.workspace_access_from_zero_client_allowed ? "ALLOW" : "DENY"
  }
  workspace_creation_properties {
    custom_security_group_id            = each.value.workspace_creation_vpc_security_group_id_custom
    default_ou                          = each.value.workspace_creation_ou
    enable_internet_access              = each.value.workspace_creation_internet_access_enabled
    enable_maintenance_mode             = each.value.workspace_creation_maintenance_mode_enabled
    user_enabled_as_local_administrator = each.value.workspace_creation_user_local_administrator_enabled
  }
}
