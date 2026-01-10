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
    for k, v in local.lx_map : v.log_db_key => merge(v, {
      bucket_name = v.destination_s3_bucket
    })... if v.log_db_enabled
  }
  create_db_x_map = {
    for k, v in local.create_db_1_map : k => v[0]
  }
  create_db_destination_map = {
    for k, v in local.create_db_table_map : k => merge(v, {
      query = <<-EOT
      SELECT
        dstaddr,
        dstport,
        sum(bytes) / 1024 / 1024 AS total_mib
      FROM ${local.create_table_name[k]}
      WHERE action = 'ACCEPT'
        AND day BETWEEN date_format(date_add('day', -7, current_date), '%Y/%m/%d')
                  AND date_format(current_date, '%Y/%m/%d')
      GROUP BY 1,2
      ORDER BY total_mib DESC
      LIMIT 50;
      EOT
    })
  }
  create_db_nat_map = {
    for k, v in local.create_db_table_map : k => merge(v, {
      query = <<-EOT
      SELECT
        pkt_dstaddr,
        dstport,
        sum(bytes) / 1024 / 1024 AS total_mib
      FROM ${local.create_table_name[k]}
      WHERE action='ACCEPT'
        AND pkt_dstaddr is not null
        AND day BETWEEN date_format(date_add('day', -7, current_date), '%Y/%m/%d')
                  AND date_format(current_date, '%Y/%m/%d')
      GROUP BY 1,2
      ORDER BY total_mib DESC
      LIMIT 50;
      EOT
    })
  }
  create_db_source_map = {
    for k, v in local.create_db_table_map : k => merge(v, {
      query = <<-EOT
      SELECT
        srcaddr,
        dstport,
        sum(bytes) / 1024 / 1024 AS total_mib
      FROM ${local.create_table_name[k]}
      WHERE action = 'ACCEPT'
        AND day BETWEEN date_format(date_add('day', -7, current_date), '%Y/%m/%d')
                  AND date_format(current_date, '%Y/%m/%d')
      GROUP BY 1,2
      ORDER BY total_mib DESC
      LIMIT 50;
      EOT
    })
  }
  create_db_table_map = {
    for k, v in local.lx_map : k => merge(v, {
      bucket_name  = v.destination_s3_bucket
      database_key = v.log_db_key
      query        = <<-EOT
      CREATE EXTERNAL TABLE IF NOT EXISTS ${local.create_table_name[k]} (
        version int,
        account_id string,
        interface_id string,
        srcaddr string,
        dstaddr string,
        srcport int,
        dstport int,
        protocol bigint,
        packets bigint,
        bytes bigint,
        start bigint,
        end_time bigint,
        action string,
        log_status string,
        vpc_id string,
        subnet_id string,
        instance_id string,
        tcp_flags int,
        type string,
        pkt_srcaddr string,
        pkt_dstaddr string,
        region string,
        az_id string,
        sublocation_type string,
        sublocation_id string,
        pkt_src_aws_service string,
        pkt_dst_aws_service string,
        flow_direction string,
        traffic_path int,

        ecs_cluster_name string,
        ecs_cluster_arn string,
        ecs_container_instance_id string,
        ecs_container_instance_arn string,
        ecs_service_name string,
        ecs_task_definition_arn string,
        ecs_task_id string,
        ecs_task_arn string,
        ecs_container_id string,
        ecs_second_container_id string,

        reject_reason string,
        resource_id string,
        encryption_status string
      )
      PARTITIONED BY (day string)
      STORED AS PARQUET
      LOCATION 's3://${v.destination_s3_bucket}/AWSLogs/${var.std_map.aws_account_id}/vpcflowlogs/${var.std_map.aws_region_name}/'
      TBLPROPERTIES
      (
        'projection.day.format'='yyyy/MM/dd',
        'projection.day.interval'='1',
        'projection.day.interval.unit'='DAYS',
        'projection.day.range'='2025/01/01,NOW',
        'projection.day.type'='date',
        'projection.enabled'='true',
        'storage.location.template'='s3://${v.destination_s3_bucket}/AWSLogs/${var.std_map.aws_account_id}/vpcflowlogs/${var.std_map.aws_region_name}/$${day}/'
      )
      EOT
    }) if v.log_db_enabled
  }
  create_table_name = {
    for k, v in local.lx_map : k => replace("${module.athena_db.data[v.log_db_key].name_effective}.${v.name_effective}", "-", "_")
  }
  l0_map = {
    for k, v in var.log_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      destination_arn                                = v.destination_arn == null ? var.log_destination_arn_default : v.destination_arn
      destination_file_format                        = v.destination_file_format == null ? var.log_destination_file_format_default : v.destination_file_format
      destination_hive_compatible_partitions_enabled = v.destination_hive_compatible_partitions_enabled == null ? var.log_destination_hive_compatible_partitions_enabled_default : v.destination_hive_compatible_partitions_enabled
      destination_per_hour_partition_enabled         = v.destination_per_hour_partition_enabled == null ? var.log_destination_per_hour_partition_enabled_default : v.destination_per_hour_partition_enabled
      destination_type                               = v.destination_type == null ? var.log_destination_type_default : v.destination_type
      iam_role_arn_cloudwatch_logs                   = v.iam_role_arn_cloudwatch_logs == null ? var.log_iam_role_arn_cloudwatch_logs_default : v.iam_role_arn_cloudwatch_logs
      iam_role_arn_cross_account_delivery            = v.iam_role_arn_cross_account_delivery == null ? var.log_iam_role_arn_cross_account_delivery_default : v.iam_role_arn_cross_account_delivery
      log_db_key                                     = v.log_db_key == null ? var.log_db_key_default : v.log_db_key
      log_format                                     = v.log_format == null ? var.log_format_default : v.log_format
      max_aggregation_interval_seconds               = v.max_aggregation_interval_seconds == null ? var.log_max_aggregation_interval_seconds_default : v.max_aggregation_interval_seconds
      source_type                                    = v.source_type == null ? var.log_source_type_default : v.source_type
      traffic_type                                   = v.traffic_type == null ? var.log_traffic_type_default : v.traffic_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      eni_id                           = local.l1_map[k].source_type == "eni" ? v.source_id : null
      log_db_enabled                   = local.l1_map[k].log_db_key != null && local.l1_map[k].destination_type == "s3"
      max_aggregation_interval_seconds = startswith(local.l1_map[k].source_type, "transit-gateway") ? 60 : local.l1_map[k].max_aggregation_interval_seconds
      regional_nat_gateway_id          = local.l1_map[k].source_type == "regional-nat-gateway" ? v.source_id : null
      subnet_id                        = local.l1_map[k].source_type == "subnet" ? v.source_id : null
      transit_gateway_attachment_id    = local.l1_map[k].source_type == "transit-gateway-attachment" ? v.source_id : null
      transit_gateway_id               = local.l1_map[k].source_type == "transit-gateway" ? v.source_id : null
      vpc_id                           = local.l1_map[k].source_type == "vpc" ? v.source_id : null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      destination_s3_bucket = local.l2_map[k].log_db_enabled ? split(":", local.l1_map[k].destination_arn)[5] : null
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
        athena = {
          db = v.log_db_enabled ? module.athena_db.data[v.log_db_key] : null
          query = {
            destination = v.log_db_enabled ? module.athena_destination_query.data[k] : null
            nat         = v.log_db_enabled ? module.athena_nat_query.data[k] : null
            source      = v.log_db_enabled ? module.athena_source_query.data[k] : null
            table       = v.log_db_enabled ? module.athena_table_query.data[k] : null
          }
        }
      }
    )
  }
}
