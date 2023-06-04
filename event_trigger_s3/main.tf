module "s3_prefix_pattern" {
  source          = "../event_pattern_s3"
  for_each        = local.event_map
  bucket_name     = each.value.s3_bucket_name
  object_key_list = each.value.s3_object_key_prefix_list
  std_map         = var.std_map
}

module "s3_suffix_pattern" {
  source               = "../event_pattern_s3"
  for_each             = local.event_map
  bucket_name          = each.value.s3_bucket_name
  object_key_is_prefix = false
  object_key_list      = each.value.s3_object_key_suffix_list
  std_map              = var.std_map
}

module "event_bus" {
  source  = "../event_bus"
  bus_map = local.bus_map
  std_map = var.std_map
}

module "trigger_prefix" {
  source    = "../event_trigger"
  event_map = local.trigger_prefix_map
  iam_data  = var.iam_data
  std_map   = var.std_map
}

module "trigger_suffix" {
  source                                          = "../event_trigger"
  event_dead_letter_queue_enabled_default         = var.event_dead_letter_queue_enabled_default
  event_definition_arn_default                    = var.event_definition_arn_default
  event_iam_policy_arn_target_default             = var.event_iam_policy_arn_target_default
  event_iam_role_arn_custom_default               = var.event_iam_role_arn_custom_default
  event_iam_role_use_custom_default               = var.event_iam_role_use_custom_default
  event_input_path_default                        = var.event_input_path_default
  event_input_transformer_path_map_default        = var.event_input_transformer_path_map_default
  event_input_transformer_template_json_default   = var.event_input_transformer_template_json_default
  event_input_transformer_template_string_default = var.event_input_transformer_template_string_default
  event_is_enabled_default                        = var.event_is_enabled_default
  event_map                                       = local.trigger_suffix_map
  event_retry_attempts_default                    = var.event_retry_attempts_default
  event_target_arn_default                        = var.event_target_arn_default
  event_target_service_default                    = var.event_target_service_default
  event_task_count_default                        = var.event_task_count_default
  iam_data                                        = var.iam_data
  std_map                                         = var.std_map
  vpc_az_key_list_default                         = var.vpc_az_key_list_default
  vpc_data_map                                    = var.vpc_data_map
  vpc_key_default                                 = var.vpc_key_default
  vpc_security_group_key_list_default             = var.vpc_security_group_key_list_default
  vpc_segment_key_default                         = var.vpc_segment_key_default
}
