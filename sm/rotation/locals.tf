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
  create_lambda_map = {
    for k, v in local.lx_map : k => merge(v, {
      environment_variable_map = v.lambda_environment_variable_map
      role_policy_attach_arn_map = {
        secret_read_write = var.secret_data_map[local.l1_map[k].secret_key].policy_map["read_write"].iam_policy_arn
      }
      source_content_local_path           = "${path.module}/rotation.py"
      source_package_created_archive_path = "${path.root}/config/secret-rotation-${v.name_context}.zip"
    }) if v.create_lambda
  }
  create_lambda_permission_map = {
    for k, v in local.lx_map : k => merge(v, {
      lambda_arn = module.lambda.data[k].lambda_arn
    }) if v.create_lambda
  }
  create_rotation_map = {
    for k, v in local.lx_map : k => merge(v, {
      lambda_arn = v.create_lambda ? module.lambda.data[k].lambda_arn : v.rotation_lambda_arn
    }) if v.create_rotation
  }
  l0_map = {
    for k, v in var.rotation_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      rotation_lambda_arn                                = v.rotation_lambda_arn == null ? var.rotation_lambda_arn_default : v.rotation_lambda_arn
      rotation_method                                    = v.rotation_method == null ? var.rotation_method_default : v.rotation_method
      rotate_immediately                                 = v.rotate_immediately == null ? var.rotation_rotate_immediately_default : v.rotate_immediately
      rotation_schedule_days                             = v.rotation_schedule_days == null ? var.rotation_schedule_days_default : v.rotation_schedule_days
      rotation_schedule_expression                       = v.rotation_schedule_expression == null ? var.rotation_schedule_expression_default : v.rotation_schedule_expression
      rotation_schedule_window                           = v.rotation_schedule_window == null ? var.rotation_schedule_window_default : v.rotation_schedule_window
      rotation_value_random_string_characters_to_exclude = v.rotation_value_random_string_characters_to_exclude == null ? var.rotation_value_random_string_characters_to_exclude_default : v.rotation_value_random_string_characters_to_exclude
      rotation_value_random_string_length                = v.rotation_value_random_string_length == null ? var.rotation_value_random_string_length_default : v.rotation_value_random_string_length
      rotation_value_key_to_replace                      = v.rotation_value_key_to_replace == null ? var.rotation_value_key_to_replace_default : v.rotation_value_key_to_replace
      rotation_value_list_max_length                     = v.rotation_value_list_max_length == null ? var.rotation_value_list_max_length_default : v.rotation_value_list_max_length
      secret_key                                         = v.secret_key == null ? k : v.secret_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      create_lambda = local.l1_map[k].rotation_lambda_arn == null && local.l1_map[k].rotation_method != null
      secret_id     = var.secret_data_map[local.l1_map[k].secret_key].secret_id
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      create_rotation = local.l1_map[k].rotation_lambda_arn != null || local.l2_map[k].create_lambda
      lambda_environment_variable_map = {
        ROTATION_METHOD                     = upper(local.l1_map[k].rotation_method)
        RANDOM_STRING_CHARACTERS_TO_EXCLUDE = local.l1_map[k].rotation_value_random_string_characters_to_exclude
        RANDOM_STRING_LENGTH                = local.l1_map[k].rotation_value_random_string_length
        ROTATION_KEY_TO_REPLACE             = local.l1_map[k].rotation_value_key_to_replace
        ROTATION_LIST_MAX_LENGTH            = local.l1_map[k].rotation_value_list_max_length
      }
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
        rotation_lambda = v.create_lambda ? module.lambda.data[k] : null
      }
    )
  }
}
