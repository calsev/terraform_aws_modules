resource "aws_athena_workgroup" "this_group" {
  for_each = local.lx_map
  configuration {
    bytes_scanned_cutoff_per_query  = each.value.byte_scanned_cutoff_per_query
    enforce_workgroup_configuration = each.value.workgroup_configuration_enforced
    engine_version {
      selected_engine_version = each.value.selected_engine_version
    }
    execution_role                     = each.value.iam_role_arn_execution
    publish_cloudwatch_metrics_enabled = each.value.publish_cloudwatch_metrics_enabled
    requester_pays_enabled             = each.value.requester_pays_enabled
    result_configuration {
      acl_configuration {
        s3_acl_option = "BUCKET_OWNER_FULL_CONTROL" # Only valid option
      }
      encryption_configuration {
        encryption_option = each.value.encryption_option
        kms_key_arn       = each.value.kms_key_arn
      }
      output_location = each.value.output_s3_bucket_location
    }
  }
  force_destroy = each.value.force_destroy_enabled
  name          = each.value.name_effective
  state         = each.value.is_enabled ? "ENABLED" : "DISABLED"
  tags          = each.value.tags
}
