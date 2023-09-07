module "name_map" {
  source             = "../name_map"
  name_infix_default = var.function_name_infix_default
  name_map           = var.function_map
  std_map            = var.std_map
}

module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_map                             = var.function_map
}

locals {
  function_map = {
    for k, v in var.function_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  l1_map = {
    for k, v in var.function_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      architecture_list                = v.architecture_list == null ? var.function_architecture_list_default : v.architecture_list
      code_signing_config_arn          = v.code_signing_config_arn == null ? var.function_code_signing_config_arn_default : v.code_signing_config_arn
      dead_letter_queue_enabled        = v.dead_letter_queue_enabled == null ? var.function_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      environment_variable_map         = v.environment_variable_map == null ? var.function_environment_variable_map_default : v.environment_variable_map
      ephemeral_storage_mib            = v.ephemeral_storage_mib == null ? var.function_ephemeral_storage_mib_default : v.ephemeral_storage_mib
      kms_key_arn                      = v.kms_key_arn == null ? var.function_kms_key_arn_default : v.kms_key_arn
      layer_version_arn_list           = v.layer_version_arn_list == null ? var.function_layer_version_arn_list_default : v.layer_version_arn_list
      memory_size_mib                  = v.memory_size_mib == null ? var.function_memory_size_mib_default : v.memory_size_mib
      publish_numbered_version         = v.publish_numbered_version == null ? var.function_publish_numbered_version_default : v.publish_numbered_version
      reserved_concurrent_executions   = v.reserved_concurrent_executions == null ? var.function_reserved_concurrent_executions_default : v.reserved_concurrent_executions
      source_image_command             = v.source_image_command == null ? var.function_source_image_command_default : v.source_image_command
      source_image_entry_point         = v.source_image_entry_point == null ? var.function_source_image_entry_point_default : v.source_image_entry_point
      source_image_repo_key            = v.source_image_repo_key == null ? var.function_source_image_repo_key_default : v.source_image_repo_key
      source_image_repo_tag            = v.source_image_repo_tag == null ? var.function_source_image_repo_tag_default : v.source_image_repo_tag
      source_image_working_directory   = v.source_image_working_directory == null ? var.function_source_image_working_directory_default : v.source_image_working_directory
      source_package_local_path        = v.source_package_local_path == null ? var.function_source_package_local_path_default : v.source_package_local_path
      source_package_s3_bucket_name    = v.source_package_s3_bucket_name == null ? var.function_source_package_s3_bucket_name_default : v.source_package_s3_bucket_name
      source_package_s3_object_key     = v.source_package_s3_object_key == null ? var.function_source_package_s3_object_key_default : v.source_package_s3_object_key
      source_package_s3_object_version = v.source_package_s3_object_version == null ? var.function_source_package_s3_object_version_default : v.source_package_s3_object_version
      timeout_seconds                  = v.timeout_seconds == null ? var.function_timeout_seconds_default : v.timeout_seconds
      tracing_mode                     = v.tracing_mode == null ? var.function_tracing_mode_default : v.tracing_mode
    })
  }
  l2_map = {
    for k, v in var.function_map : k => {
      source_is_image = local.l1_map[k].source_image_repo_key != null
    }
  }
  l3_map = {
    for k, v in var.function_map : k => {
      iam_policy_arn_source_image_read = local.l2_map[k].source_is_image ? var.ecr_data.repo_map[local.l1_map[k].source_image_repo_key].iam_policy_arn_map["read"] : null
      source_image_uri                 = local.l2_map[k].source_is_image ? "${var.ecr_data.repo_map[local.l1_map[k].source_image_repo_key].repo_url}:${local.l1_map[k].source_image_repo_tag}" : null
      source_package_handler           = local.l2_map[k].source_is_image ? null : v.source_package_handler == null ? var.function_source_package_handler_default : v.source_package_handler
      source_package_type              = local.l2_map[k].source_is_image ? "Image" : "Zip"
      source_package_hash              = local.l2_map[k].source_is_image ? null : v.source_package_hash == null ? var.function_source_package_hash_default : v.source_package_hash
      source_package_runtime           = local.l2_map[k].source_is_image ? null : v.source_package_runtime == null ? var.function_source_package_runtime_default : v.source_package_runtime
    }
  }
  l4_map = {
    for k, v in var.function_map : k => {
      source_package_snap_start_enabled = local.l3_map[k].source_package_runtime == null ? false : startswith(local.l3_map[k].source_package_runtime, "java") ? v.source_package_snap_start_enabled == null ? var.function_package_snap_start_enabled_default : v.source_package_snap_start_enabled : false
    }
  }
  log_map = {
    for k, v in local.function_map : k => merge(v, {
      name_prefix   = "/aws/lambda/" # Log group is implicitly /aws/lambda/function-name
      policy_create = false
    })
  }
  output_data = {
    for k, v in local.function_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr
        if !contains([], k_attr)
      },
      {
        arn               = aws_lambda_function.this_function[k].arn
        dead_letter_queue = module.dead_letter_queue.data[k]
        role              = module.function_role[k].data
      },
    )
  }
}
