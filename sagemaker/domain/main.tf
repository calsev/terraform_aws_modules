module "encryption_key" {
  source  = "../../kms/key"
  key_map = local.create_kms_key_map
  std_map = var.std_map
}

resource "aws_sagemaker_domain" "this_domain" {
  for_each                      = local.create_domain_map
  app_network_access_type       = each.value.app_network_access_type
  app_security_group_management = each.value.app_security_group_management
  auth_mode                     = each.value.auth_mode
  default_space_settings {
    dynamic "custom_file_system_config" {
      for_each = each.value.has_custom_file_system_config ? { this = {} } : {}
      content {
        efs_file_system_config {
          file_system_id   = each.value.efs_custom_file_system_id
          file_system_path = each.value.efs_custom_file_system_path
        }
      }
    }
    dynamic "custom_posix_user_config" {
      for_each = each.value.posix_custom_gid != null && each.value.posix_custom_uid != null ? { this = {} } : {}
      content {
        gid = each.value.posix_custom_gid
        uid = each.value.posix_custom_uid
      }
    }
    execution_role = each.value.iam_role_arn_execution
    jupyter_lab_app_settings {
      app_lifecycle_management {
        idle_settings {
          idle_timeout_in_minutes     = each.value.idle_timeout_minutes
          lifecycle_management        = each.value.idle_lifecycle_management_enabled ? "ENABLED" : "DISABLED"
          max_idle_timeout_in_minutes = each.value.idle_timeout_max_minutes
          min_idle_timeout_in_minutes = each.value.idle_timeout_min_minutes
        }
      }
      built_in_lifecycle_config_arn = each.value.jupyter_lab_built_in_lifecycle_config_arn
      dynamic "code_repository" {
        for_each = each.value.jupyter_lab_code_repository_url == null ? {} : { this = {} }
        content {
          repository_url = each.value.jupyter_lab_code_repository_url
        }
      }
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
      # emr_settings {
      #   assumable_role_arns = each.value.emr_assumable_iam_role_arn_list
      #   execution_role_arns = each.value.iam_role_arn_execution == null ? [] : [each.value.iam_role_arn_execution]
      # }
      lifecycle_config_arns = length(each.value.jupyter_lab_lifecycle_config_arn_list) == 0 ? null : each.value.jupyter_lab_lifecycle_config_arn_list
    }
    dynamic "jupyter_server_app_settings" {
      for_each = each.value.has_jupyter_server_app_settings ? { this = {} } : {}
      content {
        dynamic "code_repository" {
          for_each = each.value.jupyter_server_code_repository_url == null ? {} : { this = {} }
          content {
            repository_url = each.value.jupyter_server_code_repository_url
          }
        }
        dynamic "default_resource_spec" {
          for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
          content {
            instance_type                 = each.value.resource_default_instance_type
            lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
            sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
            sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
            sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
          }
        }
        lifecycle_config_arns = length(each.value.jupyter_server_lifecycle_config_arn_list) == 0 ? null : each.value.jupyter_server_lifecycle_config_arn_list
      }
    }
    kernel_gateway_app_settings {
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
      lifecycle_config_arns = length(each.value.kernel_gateway_lifecycle_config_arn_list) == 0 ? null : each.value.kernel_gateway_lifecycle_config_arn_list
    }
    security_groups = each.value.vpc_security_group_id_list
    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = each.value.ebs_volume_size_default_gib
        maximum_ebs_volume_size_in_gb = each.value.ebs_volume_size_max_gib
      }
    }
  }
  default_user_settings {
    auto_mount_home_efs = each.value.user_auto_mount_home_efs
    canvas_app_settings {
      direct_deploy_settings {
        status = each.value.user_canvas_direct_deploy_enabled ? "ENABLED" : "DISABLED"
      }
      emr_serverless_settings {
        execution_role_arn = each.value.iam_role_arn_execution
        status             = each.value.user_emr_serverless_enabled ? "ENABLED" : "DISABLED"
      }
      dynamic "identity_provider_oauth_settings" {
        for_each = each.value.user_canvas_identity_provider_oauth_enabled ? { this = {} } : {}
        content {
          data_source_name = each.value.user_canvas_identity_provider_oauth_data_source_name
          secret_arn       = each.value.user_canvas_identity_provider_oauth_secret_arn
          status           = each.value.user_canvas_identity_provider_oauth_enabled ? "ENABLED" : "DISABLED"
        }
      }
      kendra_settings {
        status = each.value.user_canvas_kendra_enabled ? "ENABLED" : "DISABLED"
      }
      model_register_settings {
        cross_account_model_register_role_arn = each.value.user_canvas_model_cross_account_model_registration_iam_role_arn
        status                                = each.value.user_canvas_model_cross_account_model_registration_enabled ? "ENABLED" : "DISABLED"
      }
      time_series_forecasting_settings {
        amazon_forecast_role_arn = each.value.user_canvas_time_series_forecasting_iam_role_arn
        status                   = each.value.user_canvas_time_series_forecasting_enabled ? "ENABLED" : "DISABLED"
      }
      workspace_settings {
        s3_artifact_path = each.value.s3_artifact_path
        s3_kms_key_id    = each.value.kms_key_id
      }
    }
    code_editor_app_settings {
      app_lifecycle_management {
        idle_settings {
          idle_timeout_in_minutes     = each.value.idle_timeout_minutes
          lifecycle_management        = each.value.idle_lifecycle_management_enabled ? "ENABLED" : "DISABLED"
          max_idle_timeout_in_minutes = each.value.idle_timeout_max_minutes
          min_idle_timeout_in_minutes = each.value.idle_timeout_min_minutes
        }
      }
      built_in_lifecycle_config_arn = each.value.code_editor_built_in_lifecycle_config_arn
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
      lifecycle_config_arns = length(each.value.user_code_editor_lifecycle_config_arn_list) == 0 ? null : each.value.user_code_editor_lifecycle_config_arn_list
    }
    dynamic "custom_file_system_config" {
      for_each = each.value.has_custom_file_system_config ? { this = {} } : {}
      content {
        efs_file_system_config {
          file_system_id   = each.value.efs_custom_file_system_id
          file_system_path = each.value.efs_custom_file_system_path
        }
      }
    }
    dynamic "custom_posix_user_config" {
      for_each = each.value.posix_custom_gid != null && each.value.posix_custom_uid != null ? { this = {} } : {}
      content {
        gid = each.value.posix_custom_gid
        uid = each.value.posix_custom_uid
      }
    }
    default_landing_uri = each.value.user_default_landing_uri
    execution_role      = each.value.iam_role_arn_execution
    jupyter_lab_app_settings {
      app_lifecycle_management {
        idle_settings {
          idle_timeout_in_minutes     = each.value.idle_timeout_minutes
          lifecycle_management        = each.value.idle_lifecycle_management_enabled ? "ENABLED" : "DISABLED"
          max_idle_timeout_in_minutes = each.value.idle_timeout_max_minutes
          min_idle_timeout_in_minutes = each.value.idle_timeout_min_minutes
        }
      }
      built_in_lifecycle_config_arn = each.value.jupyter_lab_built_in_lifecycle_config_arn
      dynamic "code_repository" {
        for_each = each.value.jupyter_lab_code_repository_url == null ? {} : { this = {} }
        content {
          repository_url = each.value.jupyter_lab_code_repository_url
        }
      }
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
      emr_settings {
        assumable_role_arns = each.value.emr_assumable_iam_role_arn_list
        execution_role_arns = each.value.iam_role_arn_execution == null ? [] : [each.value.iam_role_arn_execution]
      }
      lifecycle_config_arns = length(each.value.jupyter_lab_lifecycle_config_arn_list) == 0 ? null : each.value.jupyter_lab_lifecycle_config_arn_list
    }
    dynamic "jupyter_server_app_settings" {
      for_each = each.value.has_jupyter_server_app_settings ? { this = {} } : {}
      content {
        dynamic "code_repository" {
          for_each = each.value.jupyter_server_code_repository_url == null ? {} : { this = {} }
          content {
            repository_url = each.value.jupyter_server_code_repository_url
          }
        }
        dynamic "default_resource_spec" {
          for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
          content {
            instance_type                 = each.value.resource_default_instance_type
            lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
            sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
            sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
            sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
          }
        }
        lifecycle_config_arns = length(each.value.jupyter_server_lifecycle_config_arn_list) == 0 ? null : each.value.jupyter_server_lifecycle_config_arn_list
      }
    }
    kernel_gateway_app_settings {
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
      lifecycle_config_arns = length(each.value.kernel_gateway_lifecycle_config_arn_list) == 0 ? null : each.value.kernel_gateway_lifecycle_config_arn_list
    }
    r_session_app_settings {
      dynamic "custom_image" {
        for_each = each.value.custom_image_config_name != null && each.value.custom_image_name != null ? { this = {} } : {}
        content {
          app_image_config_name = each.value.custom_image_config_name
          image_name            = each.value.custom_image_name
          image_version_number  = each.value.custom_image_version_number
        }
      }
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
    }
    r_studio_server_pro_app_settings {
      access_status = each.value.r_studio_server_pro_access_enabled ? "ENABLED" : "DISABLED"
      user_group    = each.value.r_studio_server_pro_user_group
    }
    security_groups = each.value.vpc_security_group_id_list
    sharing_settings {
      notebook_output_option = each.value.user_sharing_notebook_output_enabled ? "Allowed" : "Disabled"
      s3_kms_key_id          = each.value.kms_key_id
      s3_output_path         = each.value.s3_artifact_path
    }
    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = each.value.ebs_volume_size_default_gib
        maximum_ebs_volume_size_in_gb = each.value.ebs_volume_size_max_gib
      }
    }
    studio_web_portal = each.value.studio_web_portal_enabled ? "ENABLED" : "DISABLED"
    dynamic "studio_web_portal_settings" {
      for_each = each.value.has_studio_web_portal_settings ? { this = {} } : {}
      content {
        hidden_app_types      = each.value.user_studio_web_portal_hidden_app_type_list
        hidden_instance_types = each.value.user_studio_web_portal_hidden_instance_type_list
        hidden_ml_tools       = each.value.user_studio_web_portal_hidden_ml_tool_list
      }
    }
    tensor_board_app_settings {
      dynamic "default_resource_spec" {
        for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
        content {
          instance_type                 = each.value.resource_default_instance_type
          lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
          sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
          sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
          sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
        }
      }
    }
  }
  domain_name = each.value.name_effective
  domain_settings {
    docker_settings {
      enable_docker_access      = each.value.user_domain_docker_access_enabled ? "ENABLED" : "DISABLED"
      vpc_only_trusted_accounts = each.value.user_domain_vpc_only_trusted_account_list
    }
    execution_role_identity_config = each.value.domain_execution_role_user_profile_identity_enabled ? "USER_PROFILE_NAME" : "DISABLED"
    dynamic "r_studio_server_pro_domain_settings" {
      for_each = each.value.r_studio_server_pro_access_enabled ? { this = {} } : {}
      content {
        dynamic "default_resource_spec" {
          for_each = each.value.has_custom_resource_spec ? { this = {} } : {}
          content {
            instance_type                 = each.value.resource_default_instance_type
            lifecycle_config_arn          = each.value.resource_default_lifecycle_config_arn
            sagemaker_image_arn           = each.value.resource_default_sagemaker_image_arn
            sagemaker_image_version_alias = each.value.resource_default_sagemaker_image_version_alias
            sagemaker_image_version_arn   = each.value.resource_default_sagemaker_image_version_arn
          }
        }
        domain_execution_role_arn    = each.value.iam_role_arn_execution
        r_studio_connect_url         = each.value.domain_r_studio_connect_url
        r_studio_package_manager_url = each.value.domain_r_studio_package_manager_url
      }
    }
    security_group_ids = each.value.vpc_security_group_id_list
  }
  kms_key_id = each.value.kms_key_id
  retention_policy {
    home_efs_file_system = each.value.retention_home_efs_file_system_enabled ? "Retain" : "Delete"
  }
  subnet_ids      = each.value.vpc_subnet_id_list
  tag_propagation = "ENABLED"
  tags            = each.value.tags
  vpc_id          = each.value.vpc_id
}
