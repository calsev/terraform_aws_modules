resource "aws_glue_job" "this_job" {
  for_each = local.create_job_map
  command {
    name            = each.value.command_name
    python_version  = each.value.command_python_version
    runtime         = each.value.command_runtime
    script_location = each.value.command_script_s3_uri
  }
  connections       = each.value.connection_name_list
  default_arguments = each.value.argument_default_map
  execution_class   = each.value.execution_class
  execution_property {
    max_concurrent_runs = each.value.capacity_max_concurrent_jobs
  }
  glue_version            = each.value.glue_version
  job_mode                = each.value.job_mode
  job_run_queuing_enabled = each.value.run_queuing_enabled
  maintenance_window      = each.value.maintenance_window_utc
  # max_capacity # Deprecated, use number_of_workers and worker_type
  max_retries               = each.value.retries_max
  name                      = each.value.name_effective
  non_overridable_arguments = each.value.argument_non_overridable_map
  dynamic "notification_property" {
    for_each = each.value.notification_run_delay_minutes == null ? {} : { this = {} }
    content {
      notify_delay_after = each.value.notification_run_delay_minutes
    }
  }
  number_of_workers      = each.value.capacity_num_worker_per_job
  region                 = var.std_map.aws_region_name
  role_arn               = each.value.iam_role_arn
  tags                   = each.value.tags
  timeout                = each.value.timeout_minutes
  security_configuration = each.value.security_configuration_name
  dynamic "source_control_details" {
    for_each = each.value.has_source_control ? { this = {} } : {}
    content {
      auth_strategy  = each.value.source_control_auth_strategy
      auth_token     = each.value.source_control_auth_token
      branch         = each.value.source_control_branch
      folder         = each.value.source_control_rel_path_in_repo
      last_commit_id = each.value.source_control_last_commit_id
      owner          = each.value.source_control_owner
      provider       = each.value.source_control_provider
      repository     = each.value.source_control_repository
    }
  }
  worker_type = each.value.worker_type
}
