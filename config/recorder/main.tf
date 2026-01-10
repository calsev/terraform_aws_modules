resource "aws_config_configuration_recorder" "this_recorder" {
  for_each = local.lx_map
  name     = "default" # There can be only one, so match console for import
  recording_group {
    all_supported = each.value.resource_all_supported_enabled
    exclusion_by_resource_types {
      resource_types = each.value.exclusion_by_resource_type_list
    }
    include_global_resource_types = each.value.global_resource_types_included
    recording_strategy {
      use_only = each.value.strategy_use_only
    }
    resource_types = each.value.resource_type_list
  }
  recording_mode {
    recording_frequency = each.value.mode_record_frequency
    dynamic "recording_mode_override" {
      for_each = each.value.mode_override_map
      content {
        recording_frequency = recording_mode_override.value.record_frequency
        resource_types      = recording_mode_override.value.resource_type_list
      }
    }
  }
  role_arn = each.value.iam_role_arn
}

resource "aws_config_delivery_channel" "delivery_channel" {
  for_each       = local.lx_map
  depends_on     = [aws_config_configuration_recorder.this_recorder]
  name           = "default" # There can be only one, so match console for import
  s3_bucket_name = each.value.s3_bucket_name
  s3_key_prefix  = each.value.s3_object_key_prefix
  s3_kms_key_arn = each.value.kms_key_arn
  snapshot_delivery_properties {
    delivery_frequency = each.value.snapshot_frequency
  }
  sns_topic_arn = each.value.sns_topic_arn
}

resource "aws_config_configuration_recorder_status" "this_status" {
  for_each   = local.lx_map
  depends_on = [aws_config_delivery_channel.delivery_channel]
  is_enabled = each.value.is_enabled
  name       = aws_config_configuration_recorder.this_recorder[each.key].name
}

module "athena_db" {
  source  = "../../athena/database"
  db_map  = local.create_db_x_map
  std_map = var.std_map
}

module "athena_query_table" {
  source               = "../../athena/named_query"
  athena_database_map  = module.athena_db.data
  name_prepend_default = "config_table"
  query_map            = local.create_query_table_map
  std_map              = var.std_map
}

module "athena_query_resource_type" {
  source               = "../../athena/named_query"
  athena_database_map  = module.athena_db.data
  name_prepend_default = "config_resource"
  query_map            = local.create_query_type_map
  std_map              = var.std_map
}

module "athena_query_resource_update" {
  source               = "../../athena/named_query"
  athena_database_map  = module.athena_db.data
  name_prepend_default = "config_update"
  query_map            = local.create_query_update_map
  std_map              = var.std_map
}
