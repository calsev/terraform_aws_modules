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
  build_directory = var.layer_build_directory_default == null ? "${path.root}/.build/lambda_layer" : var.layer_build_directory_default
  build_script    = "${path.module}/build_layer.py"
  create_archive_map = {
    for k, v in local.lx_map : k => v if v.source_is_local_directory
  }
  create_pip_map = {
    for k, v in local.lx_map : k => v if v.source_is_pip
  }
  create_pip_x_map = {
    for k, v in local.create_pip_map : k => merge(v, {
      pip_platform_list  = jsondecode(data.external.pip_platform[k].result.platform_list_json)
      pip_python_version = data.external.pip_platform[k].result.python_version
      pip_build_identity = local.pip_identity_map[k]
    })
  }
  create_hash_map = {
    for k, v in local.lx_map : k => v.source_is_pip ? local.pip_identity_map[k] : v.source_is_local_archive ? filebase64sha256(v.source_package_archive_local_path) : v.source_is_local_directory ? data.archive_file.package[k].output_base64sha256 : v.source_package_s3_object_hash
  }
  create_s3_map = {
    for k, v in local.lx_map : k => v if v.create_s3_object
  }
  l0_map = {
    for k, v in var.layer_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      compatible_architecture_list        = v.compatible_architecture_list == null ? var.layer_compatible_architecture_list_default : v.compatible_architecture_list
      compatible_runtime_list             = v.compatible_runtime_list == null ? var.layer_compatible_runtime_list_default : v.compatible_runtime_list
      description                         = v.description == null ? var.layer_description_default : v.description
      license_info                        = v.license_info == null ? var.layer_license_info_default : v.license_info
      permission_aws_account_id_list      = v.permission_aws_account_id_list == null ? var.layer_permission_aws_account_id_list_default : v.permission_aws_account_id_list
      pip_platform                        = v.pip_platform == null ? var.layer_pip_platform_default : v.pip_platform
      pip_requirement_list                = v.pip_requirement_list == null ? var.layer_pip_requirement_list_default : v.pip_requirement_list
      skip_destroy                        = v.skip_destroy == null ? var.layer_skip_destroy_default : v.skip_destroy
      source_package_archive_local_path   = v.source_package_archive_local_path == null ? var.layer_source_package_archive_local_path_default : v.source_package_archive_local_path
      source_package_directory_local_path = v.source_package_directory_local_path == null ? var.layer_source_package_directory_local_path_default : v.source_package_directory_local_path
      source_package_s3_bucket_name       = v.source_package_s3_bucket_name == null ? var.layer_source_package_s3_bucket_name_default : v.source_package_s3_bucket_name
      source_package_s3_object_hash       = v.source_package_s3_object_hash == null ? var.layer_source_package_s3_object_hash_default : v.source_package_s3_object_hash
      source_package_s3_object_key        = v.source_package_s3_object_key == null ? "${var.layer_source_package_s3_object_key_base_default}/layer_package_${k}.zip" : v.source_package_s3_object_key
      source_package_s3_object_version    = v.source_package_s3_object_version == null ? var.layer_source_package_s3_object_version_default : v.source_package_s3_object_version
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      source_is_pip                   = length(local.l1_map[k].pip_requirement_list) != 0                                                                                                                             # P1
      source_is_local_archive         = length(local.l1_map[k].pip_requirement_list) == 0 && local.l1_map[k].source_package_archive_local_path != null                                                                # P2
      source_is_local_directory       = length(local.l1_map[k].pip_requirement_list) == 0 && local.l1_map[k].source_package_archive_local_path == null && local.l1_map[k].source_package_directory_local_path != null # P3
      source_package_s3_path_provided = local.l1_map[k].source_package_s3_bucket_name != null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      source_is_local                     = local.l2_map[k].source_is_pip || local.l2_map[k].source_is_local_archive || local.l2_map[k].source_is_local_directory
      source_package_created_archive_path = local.l2_map[k].source_is_pip ? "${local.build_directory}/${local.l1_map[k].name_effective}.zip" : local.l2_map[k].source_is_local_directory ? v.source_package_created_archive_path == null ? "${local.l1_map[k].source_package_directory_local_path}.zip" : v.source_package_created_archive_path : null
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      create_s3_object                        = local.l3_map[k].source_is_local && local.l2_map[k].source_package_s3_path_provided
      source_is_s3_object                     = !local.l3_map[k].source_is_local && local.l2_map[k].source_package_s3_path_provided # P4
      source_package_final_archive_local_path = local.l2_map[k].source_is_local_archive ? local.l1_map[k].source_package_archive_local_path : local.l3_map[k].source_package_created_archive_path
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      source_final_is_local_path = local.l3_map[k].source_is_local && !local.l4_map[k].create_s3_object
      source_final_is_s3_object  = local.l4_map[k].source_is_s3_object || local.l4_map[k].create_s3_object
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        code_sha256         = aws_lambda_layer_version.this_layer[k].code_sha256
        created_date        = aws_lambda_layer_version.this_layer[k].created_date
        layer_arn           = aws_lambda_layer_version.this_layer[k].layer_arn
        layer_version_arn   = aws_lambda_layer_version.this_layer[k].arn
        layer_version       = aws_lambda_layer_version.this_layer[k].version
        permission          = module.permission.data[k]
        pip_build_identity  = v.source_is_pip ? local.pip_identity_map[k] : null
        pip_platform_list   = v.source_is_pip ? local.create_pip_x_map[k].pip_platform_list : null
        source_package_hash = local.create_hash_map[k]
      }
    )
  }
  # The build's identity: everything that changes what pip installs, never the zip's hash
  pip_identity_map = {
    for k, v in local.create_pip_map : k => sha256(jsonencode({
      architecture     = v.compatible_architecture_list[0]
      build_script     = filesha256(local.build_script)
      platform_list    = jsondecode(data.external.pip_platform[k].result.platform_list_json)
      python_version   = data.external.pip_platform[k].result.python_version
      requirement_list = v.pip_requirement_list
      runtime          = v.compatible_runtime_list[0]
    }))
  }
}
