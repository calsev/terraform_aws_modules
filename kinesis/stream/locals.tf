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
  l0_map = {
    for k, v in var.stream_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      aws_region_name           = v.aws_region_name == null ? var.stream_aws_region_name_default == null ? var.std_map.aws_region_name : var.stream_aws_region_name_default : v.aws_region_name
      encryption_type           = v.encryption_type == null ? var.stream_encryption_type_default : v.encryption_type
      enforce_consumer_deletion = v.enforce_consumer_deletion == null ? var.stream_enforce_consumer_deletion_default : v.enforce_consumer_deletion
      kms_key_id                = v.kms_key_id == null ? var.stream_kms_key_id_default : v.kms_key_id
      shard_count               = v.shard_count == null ? var.stream_shard_count_default : v.shard_count
      shard_level_metric_list   = v.shard_level_metric_list == null ? var.stream_shard_level_metric_list_default : v.shard_level_metric_list
      stream_capacity_mode      = v.stream_capacity_mode == null ? var.stream_capacity_mode_default : v.stream_capacity_mode
      retention_period_h        = v.retention_period_h == null ? var.stream_retention_period_h_default : v.retention_period_h
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        stream_arn = aws_kinesis_stream.this_stream[k].arn
      },
    )
  }
}
