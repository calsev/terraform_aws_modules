module "elb_target" {
  source                                                    = "../../elb/target_group"
  std_map                                                   = var.std_map
  target_health_check_consecutive_fail_threshold_default    = var.target_health_check_consecutive_fail_threshold_default
  target_health_check_consecutive_success_threshold_default = var.target_health_check_consecutive_success_threshold_default
  target_health_check_enabled_default                       = var.target_health_check_enabled_default
  target_health_check_http_path_default                     = var.target_health_check_http_path_default
  target_health_check_interval_seconds_default              = var.target_health_check_interval_seconds_default
  target_health_check_no_response_timeout_seconds_default   = var.target_health_check_no_response_timeout_seconds_default
  target_health_check_port_default                          = var.target_health_check_port_default
  target_health_check_protocol_default                      = var.target_health_check_protocol_default
  target_health_check_success_code_list_default             = var.target_health_check_success_code_list_default
  target_map                                                = local.create_target_x_map
  target_port_default                                       = var.service_elb_target_container_port_default
  target_protocol_default                                   = var.target_protocol_default
  target_protocol_http_version_default                      = var.target_protocol_http_version_default
  target_sticky_cookie_enabled_default                      = var.target_sticky_cookie_enabled_default
  vpc_data_map                                              = var.vpc_data_map
  vpc_key_default                                           = var.vpc_key_default
}

module "elb_listener" {
  source                                                       = "../../elb/listener"
  cognito_data_map                                             = var.cognito_data_map
  dns_data                                                     = var.dns_data
  elb_data_map                                                 = var.elb_data_map
  elb_target_data_map                                          = module.elb_target.data
  listener_acm_certificate_key_default                         = var.listener_acm_certificate_key_default
  listener_action_fixed_response_content_type_default          = var.listener_action_fixed_response_content_type_default
  listener_action_fixed_response_message_body_default          = var.listener_action_fixed_response_message_body_default
  listener_action_fixed_response_status_code_default           = var.listener_action_fixed_response_status_code_default
  listener_action_forward_stickiness_duration_seconds_default  = var.listener_action_forward_stickiness_duration_seconds_default
  listener_action_forward_stickiness_enabled_default           = var.listener_action_forward_stickiness_enabled_default
  listener_action_order_default                                = var.listener_action_order_default
  listener_action_redirect_host_default                        = var.listener_action_redirect_host_default
  listener_action_redirect_path_default                        = var.listener_action_redirect_path_default
  listener_action_redirect_port_default                        = var.listener_action_redirect_port_default
  listener_action_redirect_protocol_default                    = var.listener_action_redirect_protocol_default
  listener_action_redirect_query_default                       = var.listener_action_redirect_query_default
  listener_action_redirect_status_code_default                 = var.listener_action_redirect_status_code_default
  listener_action_type_default                                 = var.listener_action_type_default
  listener_auth_authentication_request_extra_param_map_default = var.listener_auth_authentication_request_extra_param_map_default
  listener_auth_cognito_client_app_key_default                 = var.listener_auth_cognito_client_app_key_default
  listener_auth_cognito_pool_key_default                       = var.listener_auth_cognito_pool_key_default
  listener_auth_oidc_authorization_endpoint_default            = var.listener_auth_oidc_authorization_endpoint_default
  listener_auth_oidc_client_id_default                         = var.listener_auth_oidc_client_id_default
  listener_auth_oidc_client_secret_default                     = var.listener_auth_oidc_client_secret_default
  listener_auth_oidc_issuer_default                            = var.listener_auth_oidc_issuer_default
  listener_auth_oidc_token_endpoint_default                    = var.listener_auth_oidc_token_endpoint_default
  listener_auth_oidc_user_info_endpoint_default                = var.listener_auth_oidc_user_info_endpoint_default
  listener_auth_on_unauthenticated_request_default             = var.listener_auth_on_unauthenticated_request_default
  listener_auth_scope_list_default                             = var.listener_auth_scope_list_default
  listener_auth_session_cookie_name_default                    = var.listener_auth_session_cookie_name_default
  listener_auth_session_timeout_seconds_default                = var.listener_auth_session_timeout_seconds_default
  listener_dns_alias_enabled_default                           = var.listener_dns_alias_enabled_default
  listener_dns_from_zone_key_default                           = var.listener_dns_from_zone_key_default
  listener_elb_key_default                                     = var.listener_elb_key_default
  listener_listen_protocol_default                             = var.listener_listen_protocol_default
  listener_map                                                 = local.create_target_x_map
  rule_host_header_pattern_list_default                        = var.rule_host_header_pattern_list_default
  rule_http_header_map_default                                 = var.rule_http_header_map_default
  rule_http_request_method_list_default                        = var.rule_http_request_method_list_default
  rule_path_pattern_list_default                               = var.rule_path_pattern_list_default
  rule_priority_default                                        = var.rule_priority_default
  rule_query_string_map_default                                = var.rule_query_string_map_default
  rule_source_ip_list_default                                  = var.rule_source_ip_list_default
  rule_listener_key_default                                    = var.rule_listener_key_default
  std_map                                                      = var.std_map
}

module "ecs_cluster" {
  source                                            = "../../ecs/compute"
  compute_auto_scaling_num_instances_max_default    = var.compute_auto_scaling_num_instances_max_default
  compute_auto_scaling_num_instances_min_default    = var.compute_auto_scaling_num_instances_min_default
  compute_health_check_type_default                 = "ELB"
  compute_image_id_default                          = var.compute_image_id_default
  compute_instance_storage_gib_default              = var.compute_instance_storage_gib_default
  compute_instance_type_default                     = var.compute_instance_type_default
  compute_key_pair_key_default                      = var.compute_key_pair_key_default
  compute_map                                       = local.create_cluster_map
  compute_provider_instance_warmup_period_s_default = var.compute_provider_instance_warmup_period_s_default
  compute_user_data_command_list_default            = var.compute_user_data_command_list_default
  elb_target_data_map                               = module.elb_target.data
  iam_data                                          = var.iam_data
  monitor_data                                      = var.monitor_data
  std_map                                           = var.std_map
  vpc_az_key_list_default                           = var.vpc_az_key_list_default
  vpc_data_map                                      = var.vpc_data_map
  vpc_key_default                                   = var.vpc_key_default
  vpc_security_group_key_list_default               = var.vpc_security_group_key_list_instance_default
  vpc_segment_key_default                           = var.vpc_segment_key_default
}

module "fargate_cluster" {
  source      = "../../ecs/compute_fargate"
  compute_map = local.create_fargate_map
  std_map     = var.std_map
}

module "ecs_task" {
  source                                            = "../../ecs/task"
  alert_enabled_default                             = var.alert_enabled_default
  ecs_cluster_data                                  = local.ecs_cluster_data
  iam_data                                          = var.iam_data
  monitor_data                                      = var.monitor_data
  role_policy_attach_arn_map_default                = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default               = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default               = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default              = var.role_policy_managed_name_map_default
  role_path_default                                 = var.role_path_default
  std_map                                           = var.std_map
  task_container_command_join_default               = var.task_container_command_join_default
  task_container_entry_point_default                = var.task_container_entry_point_default
  task_container_environment_file_list_default      = var.task_container_environment_file_list_default
  task_container_environment_map_default            = var.task_container_environment_map_default
  task_container_image_default                      = var.task_container_image_default
  task_container_mount_point_map_default            = var.task_container_mount_point_map_default
  task_container_mount_read_only_default            = var.task_container_mount_read_only_default
  task_container_port_map_default                   = var.task_container_port_map_default
  task_container_port_protocol_default              = var.task_container_port_protocol_default
  task_container_privileged_default                 = var.task_container_privileged_default
  task_container_read_only_root_file_system_default = var.task_container_read_only_root_file_system_default
  task_container_reserved_memory_gib_default        = var.task_container_reserved_memory_gib_default
  task_container_reserved_num_vcpu_default          = var.task_container_reserved_num_vcpu_default
  task_container_secret_map_default                 = var.task_container_secret_map_default
  task_container_username_default                   = var.task_container_username_default
  task_docker_volume_map_default                    = var.task_docker_volume_map_default
  task_docker_volume_auto_provision_enabled_default = var.task_docker_volume_auto_provision_enabled_default
  task_docker_volume_driver_default                 = var.task_docker_volume_driver_default
  task_docker_volume_driver_option_map_default      = var.task_docker_volume_driver_option_map_default
  task_docker_volume_label_map_default              = var.task_docker_volume_label_map_default
  task_docker_volume_scope_default                  = var.task_docker_volume_scope_default
  task_ecs_exec_enabled_default                     = var.task_ecs_exec_enabled_default
  task_efs_volume_map_default                       = var.task_efs_volume_map_default
  task_efs_authorization_access_point_id_default    = var.task_efs_authorization_access_point_id_default
  task_efs_authorization_iam_enabled_default        = var.task_efs_authorization_iam_enabled_default
  task_efs_file_system_id_default                   = var.task_efs_file_system_id_default
  task_efs_root_directory_default                   = var.task_efs_root_directory_default
  task_efs_transit_encryption_enabled_default       = var.task_efs_transit_encryption_enabled_default
  task_efs_transit_encryption_port_default          = var.task_efs_transit_encryption_port_default
  task_host_volume_map_default                      = var.task_host_volume_map_default
  task_iam_role_arn_execution_default               = var.task_iam_role_arn_execution_default
  task_map                                          = local.create_task_map
  task_resource_memory_gib_default                  = var.task_resource_memory_gib_default
  task_resource_memory_host_gib_default             = var.task_resource_memory_host_gib_default
  task_resource_num_vcpu_default                    = var.task_resource_num_vcpu_default
}

module "ecs_service" {
  source                                                = "../../ecs/service"
  dns_data                                              = var.dns_data
  ecs_cluster_data                                      = local.ecs_cluster_data
  ecs_task_definition_data_map                          = module.ecs_task.data
  elb_target_data_map                                   = module.elb_target.data
  service_desired_count_default                         = var.service_desired_count_default
  service_elb_health_check_grace_period_seconds_default = var.service_elb_health_check_grace_period_seconds_default
  service_elb_target_map_default                        = var.service_elb_target_map_default
  service_elb_target_container_name_default             = var.service_elb_target_container_name_default
  service_elb_target_container_port_default             = var.service_elb_target_container_port_default
  service_map                                           = local.create_service_map
  std_map                                               = var.std_map
  vpc_az_key_list_default                               = var.vpc_az_key_list_default
  vpc_data_map                                          = var.vpc_data_map
  vpc_key_default                                       = var.vpc_key_default
  vpc_security_group_key_list_default                   = var.vpc_security_group_key_list_default
  vpc_segment_key_default                               = var.vpc_segment_key_default
}

module "codedeploy_app" {
  source                              = "../../ci_cd/deploy/app"
  deployment_compute_platform_default = "ECS"
  deployment_map                      = local.lx_map
  std_map                             = var.std_map
}

module "codedeploy_config" {
  source         = "../../ci_cd/deploy/config"
  deployment_map = local.lx_map
  std_map        = var.std_map
}

module "codedeploy_group" {
  source                                                 = "../../ci_cd/deploy/group"
  alert_enabled_default                                  = var.alert_enabled_default
  ci_cd_account_data                                     = var.ci_cd_account_data
  deployment_app_data_map                                = module.codedeploy_app.data
  deployment_blue_green_termination_wait_minutes_default = var.deployment_blue_green_termination_wait_minutes_default
  deployment_blue_green_timeout_wait_minutes_default     = var.deployment_blue_green_timeout_wait_minutes_default
  deployment_config_data_map                             = module.codedeploy_config.data
  deployment_map                                         = local.create_deployment_map
  deployment_trigger_map_default                         = var.deployment_trigger_map_default
  ecs_cluster_data_map                                   = local.ecs_cluster_data
  ecs_service_data_map                                   = module.ecs_service.data
  elb_listener_data_map                                  = module.elb_listener.data
  elb_target_data_map                                    = module.elb_target.data
  monitor_data                                           = var.monitor_data
  std_map                                                = var.std_map
}

module "app_spec" {
  # This is currently not used by the script
  source   = "../../local_config"
  for_each = local.create_file_app_spec_x_map
  content  = each.value.revision_spec
  name     = "app"
  std_map  = var.std_map
}

resource "local_file" "deploy_script" {
  for_each        = local.create_file_deploy_script_map
  content         = each.value.deploy_script
  filename        = "${path.root}/${each.value.path_terraform_app_to_deploy_script}"
  file_permission = "0755"
}

resource "local_file" "deploy_spec" {
  for_each        = local.create_file_deploy_spec_map
  content         = each.value.deploy_spec
  filename        = "${path.root}/${each.value.path_terraform_app_to_deploy_spec}"
  file_permission = "0644"
}

module "image_build" {
  source                                   = "../../ci_cd/build_image"
  build_code_star_connection_key_default   = var.pipe_source_code_star_connection_key_default
  build_environment_size_default           = var.build_environment_size_default
  build_image_build_arch_list_default      = var.build_image_build_arch_list_default
  build_image_ecr_repo_key_default         = var.build_image_ecr_repo_key_default
  build_image_environment_key_arch_default = var.build_image_environment_key_arch_default
  build_image_environment_key_tag_default  = var.build_image_environment_key_tag_default
  build_image_tag_base_default             = var.build_image_tag_base_default
  build_source_build_spec_image_default    = var.build_source_build_spec_image_default
  build_source_build_spec_manifest_default = var.build_source_build_spec_manifest_default
  build_vpc_access_default                 = var.build_vpc_access_default
  ci_cd_account_data                       = var.ci_cd_account_data
  ecr_data_map                             = var.ecr_data_map
  repo_map                                 = local.create_ci_cd_image_map
  role_policy_attach_arn_map_default       = var.build_role_policy_attach_arn_map_default
  role_policy_create_json_map_default      = var.build_role_policy_create_json_map_default
  role_policy_inline_json_map_default      = var.build_role_policy_inline_json_map_default
  role_policy_managed_name_map_default     = var.build_role_policy_managed_name_map_default
  role_path_default                        = var.role_path_default
  std_map                                  = var.std_map
  vpc_az_key_list_default                  = var.vpc_az_key_list_default
  vpc_data_map                             = var.vpc_data_map
  vpc_key_default                          = var.vpc_key_default
  vpc_security_group_key_list_default      = var.vpc_security_group_key_list_instance_default
  vpc_segment_key_default                  = var.vpc_segment_key_default
}

module "code_build" {
  source                              = "../../ci_cd/build"
  ci_cd_account_data                  = var.ci_cd_account_data
  name_include_app_fields_default     = var.name_include_app_fields_default
  name_infix_default                  = var.name_infix_default
  repo_map                            = local.create_ci_cd_build_map
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_instance_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

module "code_pipe" {
  source                                       = "../../ci_cd/pipe_stack"
  ci_cd_account_data                           = var.ci_cd_account_data
  ci_cd_build_data_map                         = var.ci_cd_build_data_map
  ci_cd_deploy_data_map                        = local.ci_cd_deploy_data_map
  name_include_app_fields_default              = var.name_include_app_fields_default
  name_infix_default                           = var.name_infix_default
  pipe_build_data_key_default                  = var.pipe_build_data_key_default
  pipe_source_branch_default                   = var.pipe_source_branch_default
  pipe_source_code_star_connection_key_default = var.pipe_source_code_star_connection_key_default
  pipe_source_detect_changes_default           = var.pipe_source_detect_changes_default
  pipe_source_repository_id_default            = var.pipe_source_repository_id_default
  pipe_webhook_enabled_default                 = var.pipe_webhook_enabled_default
  pipe_webhook_enable_github_hook_default      = var.pipe_webhook_enable_github_hook_default
  pipe_webhook_secret_is_param_default         = var.pipe_webhook_secret_is_param_default
  pipe_map                                     = local.create_cicd_pipe_map
  std_map                                      = var.std_map
}
