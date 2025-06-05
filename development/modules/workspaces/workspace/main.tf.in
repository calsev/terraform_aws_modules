data "aws_kms_key" "workspaces" {
  key_id = "alias/aws/workspaces"
}

data "aws_workspaces_bundle" "this_bundle" {
  for_each = local.create_bundle_data_map
  name     = each.value.bundle_name
  owner    = each.value.bundle_owner
}

resource "aws_workspaces_workspace" "this_workspace" {
  for_each                       = local.create_workspace_map
  bundle_id                      = each.value.bundle_id
  directory_id                   = each.value.directory_id
  root_volume_encryption_enabled = each.value.root_volume_encryption_enabled
  tags                           = each.value.tags
  user_name                      = each.value.user_name
  user_volume_encryption_enabled = each.value.user_volume_encryption_enabled
  volume_encryption_key          = each.value.kms_key_id_volume_encryption
  workspace_properties {
    compute_type_name                         = each.value.compute_type_name
    root_volume_size_gib                      = each.value.root_volume_size_gib
    running_mode                              = each.value.running_mode
    running_mode_auto_stop_timeout_in_minutes = each.value.running_mode_auto_stop_timeout_minutes
    user_volume_size_gib                      = each.value.user_volume_size_gib
  }
}
