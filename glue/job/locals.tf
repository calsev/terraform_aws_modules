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
  create_job_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_role_arn = module.job_role[k].data.iam_role_arn
    })
  }
  l0_map = {
    for k, v in var.job_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      argument_default_map            = v.argument_default_map == null ? var.job_argument_default_map_default : v.argument_default_map
      argument_non_overridable_map    = v.argument_non_overridable_map == null ? var.job_argument_non_overridable_map_default : v.argument_non_overridable_map
      capacity_max_concurrent_jobs    = v.capacity_max_concurrent_jobs == null ? var.job_capacity_max_concurrent_jobs_default : v.capacity_max_concurrent_jobs
      capacity_num_worker_per_job     = v.capacity_num_worker_per_job == null ? var.job_capacity_num_worker_per_job_default : v.capacity_num_worker_per_job
      command_name                    = v.command_name == null ? var.job_command_name_default : v.command_name
      command_python_version          = v.command_python_version == null ? var.job_command_python_version_default : v.command_python_version
      command_runtime                 = v.command_runtime == null ? var.job_command_runtime_default : v.command_runtime
      command_script_s3_uri           = v.command_script_s3_uri == null ? var.job_command_script_s3_uri_default : v.command_script_s3_uri
      connection_key_list             = v.connection_key_list == null ? var.job_connection_key_list_default : v.connection_key_list
      execution_class                 = v.execution_class == null ? var.job_execution_class_default : v.execution_class
      glue_version                    = v.glue_version == null ? var.job_glue_version_default : v.glue_version
      job_mode                        = v.job_mode == null ? var.job_mode_default : v.job_mode
      notification_run_delay_minutes  = v.notification_run_delay_minutes == null ? var.job_notification_run_delay_minutes_default : v.notification_run_delay_minutes
      retries_max                     = v.retries_max == null ? var.job_retries_max_default : v.retries_max
      run_queuing_enabled             = v.run_queuing_enabled == null ? var.job_run_queuing_enabled_default : v.run_queuing_enabled
      security_configuration_name     = v.security_configuration_name == null ? var.job_security_configuration_name_default : v.security_configuration_name
      source_control_auth_strategy    = v.source_control_auth_strategy == null ? var.job_source_control_auth_strategy_default : v.source_control_auth_strategy
      source_control_auth_token       = v.source_control_auth_token == null ? var.job_source_control_auth_token_default : v.source_control_auth_token
      source_control_branch           = v.source_control_branch == null ? var.job_source_control_branch_default : v.source_control_branch
      source_control_last_commit_id   = v.source_control_last_commit_id == null ? var.job_source_control_last_commit_id_default : v.source_control_last_commit_id
      source_control_owner            = v.source_control_owner == null ? var.job_source_control_owner_default : v.source_control_owner
      source_control_provider         = v.source_control_provider == null ? var.job_source_control_provider_default : v.source_control_provider
      source_control_rel_path_in_repo = v.source_control_rel_path_in_repo == null ? var.job_source_control_rel_path_in_repo_default : v.source_control_rel_path_in_repo
      source_control_repository       = v.source_control_repository == null ? var.job_source_control_repository_default : v.source_control_repository
      worker_type                     = v.worker_type == null ? var.job_worker_type_default : v.worker_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      connection_id_list = [
        for k_conn in local.l1_map[k].connection_key_list : var.connection_data_map[k_conn].connection_id
      ]
      maintenance_window_utc = local.l1_map[k].command_name == "gluestreaming" ? v.maintenance_window_utc == null ? var.job_maintenance_window_utc_default : v.maintenance_window_utc : null
      timeout_minutes        = v.timeout_minutes == null ? var.job_timeout_minutes_default == null ? local.l1_map[k].command_name == "gluestreaming" ? 0 : local.l1_map[k].command_name == "glueray" ? null : 48 * 60 : var.job_timeout_minutes_default : v.timeout_minutes
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
        job_arn = aws_glue_job.this_job[k].arn
        job_id  = aws_glue_job.this_job[k].id
        role    = module.job_role[k].data
      },
    )
  }
}
