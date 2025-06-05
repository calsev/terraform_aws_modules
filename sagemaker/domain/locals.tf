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
  source                              = "../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_kms_key_map = {
    for k, v in local.lx_map : k => v if v.create_kms_key
  }
  create_domain_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_role_arn_execution = module.domain_role[k].data.iam_role_arn
      kms_key_id             = v.create_kms_key ? module.encryption_key.data[k].key_id : null
    })
  }
  create_role_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_policy_arn_kms_key_read_write = v.create_kms_key ? module.encryption_key.data[k].policy_map["read_write"].iam_policy_arn : null
    })
  }
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      app_network_access_type                                         = v.app_network_access_type == null ? var.domain_app_network_access_type_default : v.app_network_access_type
      app_security_group_management                                   = v.app_security_group_management == null ? var.domain_app_security_group_management_default : v.app_security_group_management
      auth_mode                                                       = v.auth_mode == null ? var.domain_auth_mode_default : v.auth_mode
      code_editor_built_in_lifecycle_config_arn                       = v.code_editor_built_in_lifecycle_config_arn == null ? var.domain_code_editor_built_in_lifecycle_config_arn_default : v.code_editor_built_in_lifecycle_config_arn
      create_kms_key                                                  = v.create_kms_key == null ? var.domain_create_kms_key_default : v.create_kms_key
      custom_image_config_name                                        = v.custom_image_config_name == null ? var.domain_custom_image_config_name_default : v.custom_image_config_name
      custom_image_name                                               = v.custom_image_name == null ? var.domain_custom_image_name_default : v.custom_image_name
      custom_image_version_number                                     = v.custom_image_version_number == null ? var.domain_custom_image_version_number_default : v.custom_image_version_number
      domain_execution_role_user_profile_identity_enabled             = v.domain_execution_role_user_profile_identity_enabled == null ? var.domain_execution_role_user_profile_identity_enabled_default : v.domain_execution_role_user_profile_identity_enabled
      domain_r_studio_connect_url                                     = v.domain_r_studio_connect_url == null ? var.domain_r_studio_connect_url_default : v.domain_r_studio_connect_url
      domain_r_studio_package_manager_url                             = v.domain_r_studio_package_manager_url == null ? var.domain_r_studio_package_manager_url_default : v.domain_r_studio_package_manager_url
      ebs_volume_size_default_gib                                     = v.ebs_volume_size_default_gib == null ? var.domain_ebs_volume_size_default_gib_default : v.ebs_volume_size_default_gib
      ebs_volume_size_max_gib                                         = v.ebs_volume_size_max_gib == null ? var.domain_ebs_volume_size_max_gib_default : v.ebs_volume_size_max_gib
      efs_custom_file_system_id                                       = v.efs_custom_file_system_id == null ? var.domain_efs_custom_file_system_id_default : v.efs_custom_file_system_id
      efs_custom_file_system_path                                     = v.efs_custom_file_system_path == null ? var.domain_efs_custom_file_system_path_default : v.efs_custom_file_system_path
      emr_assumable_iam_role_arn_list                                 = v.emr_assumable_iam_role_arn_list == null ? var.domain_emr_assumable_iam_role_arn_list_default : v.emr_assumable_iam_role_arn_list
      idle_lifecycle_management_enabled                               = v.idle_lifecycle_management_enabled == null ? var.domain_idle_lifecycle_management_enabled_default : v.idle_lifecycle_management_enabled
      idle_timeout_max_minutes                                        = v.idle_timeout_max_minutes == null ? var.domain_idle_timeout_max_minutes_default : v.idle_timeout_max_minutes
      idle_timeout_min_minutes                                        = v.idle_timeout_min_minutes == null ? var.domain_idle_timeout_min_minutes_default : v.idle_timeout_min_minutes
      idle_timeout_minutes                                            = v.idle_timeout_minutes == null ? var.domain_idle_timeout_minutes_default : v.idle_timeout_minutes
      jupyter_lab_built_in_lifecycle_config_arn                       = v.jupyter_lab_built_in_lifecycle_config_arn == null ? var.domain_jupyter_lab_built_in_lifecycle_config_arn_default : v.jupyter_lab_built_in_lifecycle_config_arn
      jupyter_lab_code_repository_url                                 = v.jupyter_lab_code_repository_url == null ? var.domain_jupyter_lab_code_repository_url_default : v.jupyter_lab_code_repository_url
      jupyter_lab_lifecycle_config_arn_list                           = v.jupyter_lab_lifecycle_config_arn_list == null ? var.domain_jupyter_lab_lifecycle_config_arn_list_default : v.jupyter_lab_lifecycle_config_arn_list
      jupyter_server_code_repository_url                              = v.jupyter_server_code_repository_url == null ? var.domain_jupyter_server_code_repository_url_default : v.jupyter_server_code_repository_url
      jupyter_server_lifecycle_config_arn_list                        = v.jupyter_server_lifecycle_config_arn_list == null ? var.domain_jupyter_server_lifecycle_config_arn_list_default : v.jupyter_server_lifecycle_config_arn_list
      kernel_gateway_lifecycle_config_arn_list                        = v.kernel_gateway_lifecycle_config_arn_list == null ? var.domain_kernel_gateway_lifecycle_config_arn_list_default : v.kernel_gateway_lifecycle_config_arn_list
      posix_custom_gid                                                = v.posix_custom_gid == null ? var.domain_posix_custom_gid_default : v.posix_custom_gid
      posix_custom_uid                                                = v.posix_custom_uid == null ? var.domain_posix_custom_uid_default : v.posix_custom_uid
      r_studio_server_pro_access_enabled                              = v.r_studio_server_pro_access_enabled == null ? var.domain_r_studio_server_pro_access_enabled_default : v.r_studio_server_pro_access_enabled
      r_studio_server_pro_user_group                                  = v.r_studio_server_pro_user_group == null ? var.domain_r_studio_server_pro_user_group_default : v.r_studio_server_pro_user_group
      resource_default_instance_type                                  = v.resource_default_instance_type == null ? var.domain_resource_default_instance_type_default : v.resource_default_instance_type
      resource_default_lifecycle_config_arn                           = v.resource_default_lifecycle_config_arn == null ? var.domain_resource_default_lifecycle_config_arn_default : v.resource_default_lifecycle_config_arn
      resource_default_sagemaker_image_arn                            = v.resource_default_sagemaker_image_arn == null ? var.domain_resource_default_sagemaker_image_arn_default : v.resource_default_sagemaker_image_arn
      resource_default_sagemaker_image_version_alias                  = v.resource_default_sagemaker_image_version_alias == null ? var.domain_resource_default_sagemaker_image_version_alias_default : v.resource_default_sagemaker_image_version_alias
      resource_default_sagemaker_image_version_arn                    = v.resource_default_sagemaker_image_version_arn == null ? var.domain_resource_default_sagemaker_image_version_arn_default : v.resource_default_sagemaker_image_version_arn
      retention_home_efs_file_system_enabled                          = v.retention_home_efs_file_system_enabled == null ? var.domain_retention_home_efs_file_system_enabled_default : v.retention_home_efs_file_system_enabled
      s3_bucket_key                                                   = v.s3_bucket_key == null ? var.domain_s3_bucket_key_default : v.s3_bucket_key
      studio_web_portal_enabled                                       = v.studio_web_portal_enabled == null ? var.domain_studio_web_portal_enabled_default : v.studio_web_portal_enabled
      user_auto_mount_home_efs                                        = v.user_auto_mount_home_efs == null ? var.domain_user_auto_mount_home_efs_default : v.user_auto_mount_home_efs
      user_canvas_direct_deploy_enabled                               = v.user_canvas_direct_deploy_enabled == null ? var.domain_user_canvas_direct_deploy_enabled_default : v.user_canvas_direct_deploy_enabled
      user_canvas_identity_provider_oauth_data_source_name            = v.user_canvas_identity_provider_oauth_data_source_name == null ? var.domain_user_canvas_identity_provider_oauth_data_source_name_default : v.user_canvas_identity_provider_oauth_data_source_name
      user_canvas_identity_provider_oauth_enabled                     = v.user_canvas_identity_provider_oauth_enabled == null ? var.domain_user_canvas_identity_provider_oauth_enabled_default : v.user_canvas_identity_provider_oauth_enabled
      user_canvas_identity_provider_oauth_secret_arn                  = v.user_canvas_identity_provider_oauth_secret_arn == null ? var.domain_user_canvas_identity_provider_oauth_secret_arn_default : v.user_canvas_identity_provider_oauth_secret_arn
      user_canvas_kendra_enabled                                      = v.user_canvas_kendra_enabled == null ? var.domain_user_canvas_kendra_enabled_default : v.user_canvas_kendra_enabled
      user_canvas_model_cross_account_model_registration_enabled      = v.user_canvas_model_cross_account_model_registration_enabled == null ? var.domain_user_canvas_model_cross_account_model_registration_enabled_default : v.user_canvas_model_cross_account_model_registration_enabled
      user_canvas_model_cross_account_model_registration_iam_role_arn = v.user_canvas_model_cross_account_model_registration_iam_role_arn == null ? var.domain_user_canvas_model_cross_account_model_registration_iam_role_arn_default : v.user_canvas_model_cross_account_model_registration_iam_role_arn
      user_canvas_time_series_forecasting_enabled                     = v.user_canvas_time_series_forecasting_enabled == null ? var.domain_user_canvas_time_series_forecasting_enabled_default : v.user_canvas_time_series_forecasting_enabled
      user_canvas_time_series_forecasting_iam_role_arn                = v.user_canvas_time_series_forecasting_iam_role_arn == null ? var.domain_user_canvas_time_series_forecasting_iam_role_arn_default : v.user_canvas_time_series_forecasting_iam_role_arn
      user_code_editor_lifecycle_config_arn_list                      = v.user_code_editor_lifecycle_config_arn_list == null ? var.domain_user_code_editor_lifecycle_config_arn_list_default : v.user_code_editor_lifecycle_config_arn_list
      user_default_landing_uri                                        = v.user_default_landing_uri == null ? var.domain_user_default_landing_uri_default : v.user_default_landing_uri
      user_domain_docker_access_enabled                               = v.user_domain_docker_access_enabled == null ? var.domain_user_domain_docker_access_enabled_default : v.user_domain_docker_access_enabled
      user_domain_vpc_only_trusted_account_list                       = v.user_domain_vpc_only_trusted_account_list == null ? var.domain_user_domain_vpc_only_trusted_account_list_default : v.user_domain_vpc_only_trusted_account_list
      user_emr_serverless_enabled                                     = v.user_emr_serverless_enabled == null ? var.domain_user_emr_serverless_enabled_default : v.user_emr_serverless_enabled
      user_sharing_notebook_output_enabled                            = v.user_sharing_notebook_output_enabled == null ? var.domain_user_sharing_notebook_output_enabled_default : v.user_sharing_notebook_output_enabled
      user_studio_web_portal_hidden_app_type_list                     = v.user_studio_web_portal_hidden_app_type_list == null ? var.domain_user_studio_web_portal_hidden_app_type_list_default : v.user_studio_web_portal_hidden_app_type_list
      user_studio_web_portal_hidden_instance_type_list                = v.user_studio_web_portal_hidden_instance_type_list == null ? var.domain_user_studio_web_portal_hidden_instance_type_list_default : v.user_studio_web_portal_hidden_instance_type_list
      user_studio_web_portal_hidden_ml_tool_list                      = v.user_studio_web_portal_hidden_ml_tool_list == null ? var.domain_user_studio_web_portal_hidden_ml_tool_list_default : v.user_studio_web_portal_hidden_ml_tool_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      has_custom_file_system_config       = local.l1_map[k].efs_custom_file_system_id != null && local.l1_map[k].efs_custom_file_system_path != null
      has_custom_image_spec               = local.l1_map[k].custom_image_config_name != null && local.l1_map[k].custom_image_name != null
      has_custom_resource_spec            = local.l1_map[k].resource_default_instance_type != null || local.l1_map[k].resource_default_lifecycle_config_arn != null || local.l1_map[k].resource_default_sagemaker_image_arn != null || local.l1_map[k].resource_default_sagemaker_image_version_alias != null || local.l1_map[k].resource_default_sagemaker_image_version_arn != null
      has_kernel_gateway_lifecycle_config = length(local.l1_map[k].kernel_gateway_lifecycle_config_arn_list) != 0
      has_studio_web_portal_settings      = length(local.l1_map[k].user_studio_web_portal_hidden_app_type_list) != 0 || length(local.l1_map[k].user_studio_web_portal_hidden_instance_type_list) != 0 || length(local.l1_map[k].user_studio_web_portal_hidden_ml_tool_list) != 0
      iam_policy_arn_s3_bucket_read_write = local.l1_map[k].s3_bucket_key == null ? null : var.s3_data_map[local.l1_map[k].s3_bucket_key].policy.policy_map["read_write"].iam_policy_arn
      s3_bucket_name                      = local.l1_map[k].s3_bucket_key == null ? null : var.s3_data_map[local.l1_map[k].s3_bucket_key].name_effective
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      has_jupyter_server_app_settings = local.l1_map[k].jupyter_server_code_repository_url != null || local.l2_map[k].has_custom_resource_spec || length(local.l1_map[k].jupyter_server_lifecycle_config_arn_list) != 0
      s3_artifact_path                = local.l2_map[k].s3_bucket_name == null ? null : "s3://${local.l2_map[k].s3_bucket_name}"
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        domain_arn                                   = aws_sagemaker_domain.this_domain[k].arn
        domain_home_efs_file_system_id               = aws_sagemaker_domain.this_domain[k].home_efs_file_system_id
        domain_id                                    = aws_sagemaker_domain.this_domain[k].id
        domain_security_group_id_for_domain_boundary = aws_sagemaker_domain.this_domain[k].security_group_id_for_domain_boundary
        domain_sso_app_arn                           = aws_sagemaker_domain.this_domain[k].single_sign_on_application_arn
        domain_sso_app_instance_id                   = aws_sagemaker_domain.this_domain[k].single_sign_on_managed_application_instance_id
        domain_url                                   = aws_sagemaker_domain.this_domain[k].url
        kms_key                                      = v.create_kms_key ? module.encryption_key.data[k] : null
        role                                         = module.domain_role[k].data
      }
    )
  }
}
