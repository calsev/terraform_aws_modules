data "external" "pip_platform" {
  for_each = local.create_pip_map
  program  = [var.layer_pip_python_executable_default, local.build_script, "platform"]
  query = {
    architecture = join(",", each.value.compatible_architecture_list)
    pip_platform = each.value.pip_platform == null ? "" : each.value.pip_platform
    runtime      = join(",", each.value.compatible_runtime_list)
  }
  lifecycle {
    precondition {
      condition     = length(each.value.compatible_runtime_list) == 1 && alltrue([for runtime in each.value.compatible_runtime_list : can(regex("^python3\\.[0-9]+$", runtime))])
      error_message = "Layer ${each.key}: a pip source needs exactly one compatible Python runtime, such as [\"python3.14\"]; use a separate layer for each runtime"
    }
    precondition {
      condition     = length(each.value.compatible_architecture_list) == 1 && alltrue([for arch in each.value.compatible_architecture_list : contains(["arm64", "x86_64"], arch)])
      error_message = "Layer ${each.key}: a pip source needs exactly one compatible architecture, arm64 or x86_64; use a separate layer for each architecture"
    }
  }
}

resource "terraform_data" "pip_build" {
  for_each = local.create_pip_x_map
  # The zip is git-ignored, so rebuild whenever anything that reads it is created or
  # replaced: every argument of the layer version forces a new one, and the S3
  # object's bucket and key force a new upload. Keep this in step with both resources.
  triggers_replace = {
    compatible_architecture_list = each.value.compatible_architecture_list
    compatible_runtime_list      = each.value.compatible_runtime_list
    description                  = each.value.description
    identity                     = each.value.pip_build_identity
    license_info                 = each.value.license_info
    name_effective               = each.value.name_effective
    region                       = var.std_map.aws_region_name
    s3_bucket                    = each.value.source_final_is_s3_object ? each.value.source_package_s3_bucket_name : null
    s3_key                       = each.value.source_final_is_s3_object ? each.value.source_package_s3_object_key : null
    s3_object_version            = each.value.source_final_is_s3_object ? each.value.source_package_s3_object_version : null
    skip_destroy                 = each.value.skip_destroy
    zip_path                     = each.value.source_package_created_archive_path
  }
  provisioner "local-exec" {
    # The JSON spec is the script's last argument, so nothing passes through a shell
    command = jsonencode({
      architecture     = each.value.compatible_architecture_list[0]
      platform_list    = each.value.pip_platform_list
      python_version   = each.value.pip_python_version
      requirement_list = each.value.pip_requirement_list
      zip_path         = each.value.source_package_created_archive_path
    })
    interpreter = [var.layer_pip_python_executable_default, local.build_script, "build"]
  }
}

data "archive_file" "package" {
  for_each    = local.create_archive_map
  type        = "zip"
  output_path = each.value.source_package_created_archive_path
  source_dir  = each.value.source_package_directory_local_path
}

resource "aws_s3_object" "package" {
  for_each    = local.create_s3_map
  bucket      = each.value.source_package_s3_bucket_name
  key         = each.value.source_package_s3_object_key
  source      = each.value.source_package_final_archive_local_path
  source_hash = local.create_hash_map[each.key]
  depends_on  = [terraform_data.pip_build]
}

resource "aws_lambda_layer_version" "this_layer" {
  for_each                 = local.lx_map
  compatible_architectures = each.value.compatible_architecture_list
  compatible_runtimes      = each.value.compatible_runtime_list
  description              = each.value.description
  filename                 = each.value.source_final_is_local_path ? each.value.source_package_final_archive_local_path : null
  layer_name               = each.value.name_effective
  license_info             = each.value.license_info
  region                   = var.std_map.aws_region_name
  s3_bucket                = each.value.source_final_is_s3_object ? each.value.source_package_s3_bucket_name : null
  s3_key                   = each.value.source_final_is_s3_object ? each.value.source_package_s3_object_key : null
  s3_object_version        = each.value.source_final_is_s3_object ? each.value.source_package_s3_object_version : null
  skip_destroy             = each.value.skip_destroy
  source_code_hash         = local.create_hash_map[each.key]
  depends_on               = [aws_s3_object.package, terraform_data.pip_build]
  lifecycle {
    precondition {
      condition     = each.value.source_is_local || each.value.source_is_s3_object
      error_message = "Layer ${each.key}: provide pip requirements, a local archive or directory, or an S3 bucket holding the object"
    }
  }
}

module "permission" {
  source                                 = "../../lambda/layer_permission"
  permission_aws_account_id_list_default = null
  permission_map = {
    for k, v in local.lx_map : k => {
      aws_account_id_list = v.permission_aws_account_id_list
      layer_version_arn   = aws_lambda_layer_version.this_layer[k].arn
      skip_destroy        = v.skip_destroy
    }
  }
  std_map = var.std_map
}
