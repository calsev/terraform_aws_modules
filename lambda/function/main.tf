module "log_group" {
  source  = "../../cw/log_group"
  log_map = local.log_map
  std_map = var.std_map
}

module "dead_letter_queue" {
  source    = "../../sqs/dead_letter_queue"
  queue_map = local.lx_map
  std_map   = var.std_map
}

data "archive_file" "package" {
  for_each    = local.create_archive_map
  type        = "zip"
  output_path = each.value.source_package_directory_archive_path
  source_dir  = each.value.source_package_directory_local_path
}

resource "aws_s3_object" "package" {
  for_each    = local.create_s3_map
  bucket      = each.value.source_package_s3_bucket_name
  key         = each.value.source_package_s3_object_key
  source      = each.value.source_package_final_archive_local_path
  source_hash = local.create_hash_map[each.key]
}

resource "aws_lambda_function" "this_function" {
  for_each                = local.lx_map
  architectures           = each.value.architecture_list
  code_signing_config_arn = each.value.code_signing_config_arn
  dynamic "dead_letter_config" {
    for_each = each.value.dead_letter_queue_enabled ? { this = {} } : {}
    content {
      target_arn = module.dead_letter_queue.data[each.key].arn
    }
  }
  environment {
    variables = each.value.environment_variable_map
  }
  ephemeral_storage {
    size = each.value.ephemeral_storage_mib
  }
  filename = each.value.source_final_is_local_path ? each.value.source_package_final_archive_local_path : null
  # file_system_config # TODO
  function_name = each.value.name_effective
  handler       = each.value.source_package_handler
  dynamic "image_config" {
    for_each = each.value.source_image_uri == null ? {} : { this = {} }
    content {
      command           = each.value.source_image_command
      entry_point       = each.value.source_image_entry_point
      working_directory = each.value.source_image_working_directory
    }
  }
  image_uri                      = each.value.source_image_uri
  kms_key_arn                    = each.value.kms_key_arn
  layers                         = each.value.layer_version_arn_list
  memory_size                    = each.value.memory_size_mib
  package_type                   = each.value.source_package_type
  publish                        = each.value.publish_numbered_version
  reserved_concurrent_executions = each.value.reserved_concurrent_executions
  role                           = module.function_role[each.key].data.iam_role_arn
  runtime                        = each.value.source_package_runtime
  s3_bucket                      = each.value.source_final_is_s3_object ? each.value.source_package_s3_bucket_name : null
  s3_key                         = each.value.source_final_is_s3_object ? each.value.source_package_s3_object_key : null
  s3_object_version              = each.value.source_package_s3_object_version
  skip_destroy                   = false
  source_code_hash               = local.create_hash_map[each.key]
  dynamic "snap_start" {
    for_each = each.value.source_package_snap_start_enabled ? { this = {} } : {}
    content {
      apply_on = "PublishedVersions"
    }
  }
  tags    = each.value.tags
  timeout = each.value.timeout_seconds
  dynamic "tracing_config" {
    for_each = each.value.tracing_mode == null ? {} : { this = {} }
    content {
      mode = each.value.tracing_mode
    }
  }
  vpc_config {
    security_group_ids = each.value.vpc_security_group_id_list
    subnet_ids         = each.value.vpc_subnet_id_list
  }
}

# TODO Fail alert
