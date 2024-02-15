module "name_map" {
  source             = "../../name_map"
  name_infix_default = var.function_name_infix_default
  name_map           = local.l0_map
  std_map            = var.std_map
}

module "policy_map" {
  source                      = "../../iam/policy_name_map"
  name_map                    = var.function_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_map                             = local.l0_map
}

locals {
  create_archive_map = {
    for k, v in local.lx_map : k => v if v.source_is_local_directory
  }
  create_hash_map = {
    for k, v in local.lx_map : k => local.l3_map[k].source_is_local_archive ? filebase64sha256(v.source_package_archive_local_path) : local.l4_map[k].source_is_local_directory ? data.archive_file.package[k].output_base64sha256 : v.source_is_s3_object ? v.source_package_s3_object_hash : null
  }
  create_s3_map = {
    for k, v in local.lx_map : k => v if v.create_s3_object
  }
  l0_map = {
    for k, v in var.function_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], module.vpc_map.data[k], {
      architecture_list                   = v.architecture_list == null ? var.function_architecture_list_default : v.architecture_list
      code_signing_config_arn             = v.code_signing_config_arn == null ? var.function_code_signing_config_arn_default : v.code_signing_config_arn
      dead_letter_queue_enabled           = v.dead_letter_queue_enabled == null ? var.function_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      environment_variable_map            = v.environment_variable_map == null ? var.function_environment_variable_map_default : v.environment_variable_map
      ephemeral_storage_mib               = v.ephemeral_storage_mib == null ? var.function_ephemeral_storage_mib_default : v.ephemeral_storage_mib
      kms_key_arn                         = v.kms_key_arn == null ? var.function_kms_key_arn_default : v.kms_key_arn
      layer_version_arn_list              = v.layer_version_arn_list == null ? var.function_layer_version_arn_list_default : v.layer_version_arn_list
      memory_size_mib                     = v.memory_size_mib == null ? var.function_memory_size_mib_default : v.memory_size_mib
      publish_numbered_version            = v.publish_numbered_version == null ? var.function_publish_numbered_version_default : v.publish_numbered_version
      reserved_concurrent_executions      = v.reserved_concurrent_executions == null ? var.function_reserved_concurrent_executions_default : v.reserved_concurrent_executions
      source_image_command                = v.source_image_command == null ? var.function_source_image_command_default : v.source_image_command
      source_image_entry_point            = v.source_image_entry_point == null ? var.function_source_image_entry_point_default : v.source_image_entry_point
      source_image_repo_key               = v.source_image_repo_key == null ? var.function_source_image_repo_key_default : v.source_image_repo_key
      source_image_repo_tag               = v.source_image_repo_tag == null ? var.function_source_image_repo_tag_default : v.source_image_repo_tag
      source_image_working_directory      = v.source_image_working_directory == null ? var.function_source_image_working_directory_default : v.source_image_working_directory
      source_package_archive_local_path   = v.source_package_archive_local_path == null ? var.function_source_package_archive_local_path_default : v.source_package_archive_local_path
      source_package_directory_local_path = v.source_package_directory_local_path == null ? var.function_source_package_directory_local_path_default : v.source_package_directory_local_path
      source_package_s3_bucket_name       = v.source_package_s3_bucket_name == null ? var.function_source_package_s3_bucket_name_default : v.source_package_s3_bucket_name
      source_package_s3_object_hash       = v.source_package_s3_object_hash == null ? var.function_source_package_s3_object_hash_default : v.source_package_s3_object_hash
      source_package_s3_object_key        = v.source_package_s3_object_key == null ? "${var.function_source_package_s3_object_key_base_default}/deployment_package_${k}.zip" : v.source_package_s3_object_key
      source_package_s3_object_version    = v.source_package_s3_object_version == null ? var.function_source_package_s3_object_version_default : v.source_package_s3_object_version
      timeout_seconds                     = v.timeout_seconds == null ? var.function_timeout_seconds_default : v.timeout_seconds
      tracing_mode                        = v.tracing_mode == null ? var.function_tracing_mode_default : v.tracing_mode
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      source_is_image                 = local.l1_map[k].source_image_repo_key != null
      source_package_s3_path_provided = local.l1_map[k].source_package_s3_bucket_name != null && local.l1_map[k].source_package_s3_object_key != null ? true : false
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      iam_policy_arn_source_image_read = local.l2_map[k].source_is_image ? var.ecr_data.repo_map[local.l1_map[k].source_image_repo_key].iam_policy_arn_map["read"] : null
      source_image_uri                 = local.l2_map[k].source_is_image ? "${var.ecr_data.repo_map[local.l1_map[k].source_image_repo_key].repo_url}:${local.l1_map[k].source_image_repo_tag}" : null
      source_is_local_archive          = !local.l2_map[k].source_is_image && local.l1_map[k].source_package_archive_local_path != null
      source_package_handler           = local.l2_map[k].source_is_image ? null : v.source_package_handler == null ? var.function_source_package_handler_default : v.source_package_handler
      source_package_type              = local.l2_map[k].source_is_image ? "Image" : "Zip"
      source_package_runtime           = local.l2_map[k].source_is_image ? null : v.source_package_runtime == null ? var.function_source_package_runtime_default : v.source_package_runtime
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      source_is_local_directory         = !local.l2_map[k].source_is_image && !local.l3_map[k].source_is_local_archive && local.l1_map[k].source_package_directory_local_path != null
      source_package_snap_start_enabled = local.l3_map[k].source_package_runtime == null ? false : startswith(local.l3_map[k].source_package_runtime, "java") ? v.source_package_snap_start_enabled == null ? var.function_package_snap_start_enabled_default : v.source_package_snap_start_enabled : false
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      source_is_s3_object                   = local.l2_map[k].source_is_image || local.l3_map[k].source_is_local_archive || local.l4_map[k].source_is_local_directory ? false : local.l2_map[k].source_package_s3_path_provided ? true : file("Must provide a code source")
      source_package_directory_archive_path = local.l4_map[k].source_is_local_directory ? v.source_package_directory_archive_path == null ? "${local.l1_map[k].source_package_directory_local_path}.zip" : v.source_package_directory_archive_path : null
    }
  }
  l6_map = {
    for k, v in local.l0_map : k => {
      create_s3_object                        = !local.l5_map[k].source_is_s3_object && local.l2_map[k].source_package_s3_path_provided
      source_package_final_archive_local_path = local.l3_map[k].source_is_local_archive ? local.l1_map[k].source_package_archive_local_path : local.l4_map[k].source_is_local_directory ? local.l5_map[k].source_package_directory_archive_path : null
    }
  }
  l7_map = {
    for k, v in local.l0_map : k => {
      source_final_is_local_path = (local.l3_map[k].source_is_local_archive || local.l4_map[k].source_is_local_directory) && !local.l6_map[k].create_s3_object
      source_final_is_s3_object  = local.l5_map[k].source_is_s3_object || local.l6_map[k].create_s3_object
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k])
  }
  log_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_prefix   = "/aws/lambda/" # Log group is implicitly /aws/lambda/function-name
      policy_create = false
    })
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr
        if !contains([], k_attr)
      },
      module.function_policy[k].data,
      {
        arn                 = aws_lambda_function.this_function[k].arn
        dead_letter_queue   = module.dead_letter_queue.data[k]
        invoke_arn          = aws_lambda_function.this_function[k].invoke_arn
        role                = module.function_role[k].data
        source_package_hash = local.create_hash_map[k]
      },
    )
  }
}
