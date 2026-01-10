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
  create_db_1_map = {
    for k, v in local.lx_map : v.cost_query_db_key => merge(v, {
      bucket_name = v.s3_bucket_name
    })... if v.cost_query_enabled
  }
  create_db_x_map = {
    for k, v in local.create_db_1_map : k => v[0]
  }
  create_table_name = {
    for k, v in local.lx_map : k => replace("${module.athena_db.data[v.cost_query_db_key].name_effective}.${v.name_effective}", "-", "_")
  }
  create_query_table_map = {
    for k, v in local.lx_map : k => merge(v, {
      bucket_name  = v.s3_bucket_name
      database_key = v.cost_query_db_key
      query        = <<-EOT
      CREATE EXTERNAL TABLE IF NOT EXISTS ${local.create_table_name[k]} (
        fileversion string,
        configsnapshotid string,
        configurationitems array<
          struct<
            configurationitemversion:string,
            configurationitemcapturetime:string,
            configurationstateid:bigint,
            awsaccountid:string,
            configurationitemstatus:string,
            resourcetype:string,
            resourceid:string,
            resourcename:string,
            arn:string,
            awsregion:string,
            availabilityzone:string,
            configuration:string,
            supplementaryconfiguration:map<string,string>,
            tags:map<string,string>
          >
        >
      )
      ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
      LOCATION 's3://${v.s3_bucket_name}${v.s3_log_key_prefix}/AWSLogs/${var.std_map.aws_account_id}/Config/${var.std_map.aws_region_name}/';
      EOT
    }) if v.cost_query_enabled
  }
  create_query_type_map = {
    for k, v in local.create_query_table_map : k => merge(v, {
      query = <<-EOT
      SELECT
        ci.resourcetype AS resource_type,
        COUNT(*)        AS ci_count
      FROM ${local.create_table_name[k]}
      CROSS JOIN UNNEST(configurationitems) AS t(ci)
      WHERE "$path" LIKE '%ConfigHistory%'
        AND from_iso8601_timestamp(ci.configurationitemcapturetime)
              >= current_timestamp - INTERVAL '1' DAY
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 50;
      EOT
    })
  }
  create_query_update_map = {
    for k, v in local.create_query_table_map : k => merge(v, {
      query = <<-EOT
      WITH per_resource AS (
        SELECT
          ci.resourcetype AS resource_type,
          ci.resourceid   AS resource_id,
          COUNT(*)        AS ci_count_24h
        FROM ${local.create_table_name[k]}
        CROSS JOIN UNNEST(configurationitems) AS t(ci)
        WHERE "$path" LIKE '%ConfigHistory%'
          AND from_iso8601_timestamp(ci.configurationitemcapturetime)
                >= current_timestamp - INTERVAL '1' DAY
        GROUP BY 1, 2
      ),
      summary AS (
        SELECT
          resource_type,
          COUNT(*)                             AS resources_seen_24h,
          SUM(ci_count_24h)                    AS total_cis_24h,
          AVG(ci_count_24h)                    AS avg_cis_per_resource_24h,
          approx_percentile(ci_count_24h, 0.5) AS p50_cis_per_resource_24h,
          approx_percentile(ci_count_24h, 0.9) AS p90_cis_per_resource_24h,
          MAX(ci_count_24h)                    AS max_cis_per_resource_24h
        FROM per_resource
        GROUP BY 1
      )
      SELECT *
      FROM summary
      ORDER BY total_cis_24h DESC
      LIMIT 50;
      EOT
    })
  }
  l0_map = {
    for k, v in var.record_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      cost_query_db_key              = v.cost_query_db_key == null ? var.record_cost_query_db_key_default : v.cost_query_db_key
      global_resource_types_included = v.global_resource_types_included == null ? var.record_global_resource_types_included_default : v.global_resource_types_included
      iam_role_arn                   = v.iam_role_arn == null ? var.record_iam_role_arn_default : v.iam_role_arn
      is_enabled                     = v.is_enabled == null ? var.record_is_enabled_default : v.is_enabled
      kms_key_key                    = v.kms_key_key == null ? var.record_kms_key_key_default : v.kms_key_key
      mode_override_map              = v.mode_override_map == null ? var.record_mode_override_map_default : v.mode_override_map
      mode_record_frequency          = v.mode_record_frequency == null ? var.record_mode_record_frequency_default : v.mode_record_frequency
      resource_all_supported_enabled = v.resource_all_supported_enabled == null ? var.record_resource_all_supported_enabled_default : v.resource_all_supported_enabled
      resource_type_list             = v.resource_type_list == null ? var.record_resource_type_list_default : v.resource_type_list
      s3_bucket_key                  = v.s3_bucket_key == null ? var.record_s3_bucket_key_default : v.s3_bucket_key
      s3_object_key_prefix           = v.s3_object_key_prefix == null ? var.record_s3_object_key_prefix_default : v.s3_object_key_prefix
      snapshot_frequency             = v.snapshot_frequency == null ? var.record_snapshot_frequency_default : v.snapshot_frequency
      sns_topic_key                  = v.sns_topic_key == null ? var.record_sns_topic_key_default : v.sns_topic_key
      strategy_use_only              = v.strategy_use_only == null ? var.record_strategy_use_only_default : v.strategy_use_only
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      cost_query_enabled              = local.l1_map[k].cost_query_db_key != null
      exclusion_by_resource_type_list = local.l1_map[k].resource_all_supported_enabled ? null : v.exclusion_by_resource_type_list == null ? var.record_exclusion_by_resource_type_list_default : v.exclusion_by_resource_type_list
      kms_key_arn                     = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].key_arn
      s3_log_key_prefix               = local.l1_map[k].s3_object_key_prefix == null ? "" : "/${local.l1_map[k].s3_object_key_prefix}"
      mode_override_map = {
        for k_mode, v_mode in local.l1_map[k].mode_override_map : k_mode => merge(v_mode, {
          record_frequency   = v_mode.record_frequency == null ? var.record_mode_override_record_frequency_default : v_mode.record_frequency
          resource_type_list = v_mode.resource_type_list == null ? var.record_mode_override_resource_type_list_default : v_mode.resource_type_list
        })
      }
      resource_type_list = local.l1_map[k].resource_all_supported_enabled ? [] : local.l1_map[k].resource_type_list
      s3_bucket_name     = var.s3_data_map[local.l1_map[k].s3_bucket_key].name_effective
      sns_topic_arn      = local.l1_map[k].sns_topic_key == null ? null : var.sns_data.topic_map[local.l1_map[k].sns_topic_key].topic_arn
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
        athena = {
          db = v.cost_query_enabled ? module.athena_db.data[v.cost_query_db_key] : null
          query = {
            resource_type   = v.cost_query_enabled ? module.athena_query_resource_type.data[k] : null
            resource_update = v.cost_query_enabled ? module.athena_query_resource_update.data[k] : null
            table           = v.cost_query_enabled ? module.athena_query_table.data[k] : null
          }
        }
      }
    )
  }
}
