variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "app_map" {
  type = map(object({
    app_action_order_default_forward = optional(number)
    action_map = optional(map(object({
      action_fixed_response_content_type         = optional(string)
      action_fixed_response_message_body         = optional(string)
      action_fixed_response_status_code          = optional(number)
      action_forward_stickiness_duration_seconds = optional(number)
      action_forward_stickiness_enabled          = optional(bool)
      action_forward_target_group_map = optional(map(object({
        target_group_weight = optional(number)
      })))
      action_order                                = optional(number)
      action_redirect_host                        = optional(string)
      action_redirect_path                        = optional(string)
      action_redirect_port                        = optional(number)
      action_redirect_protocol                    = optional(string)
      action_redirect_query                       = optional(string)
      action_redirect_status_code                 = optional(string)
      action_type                                 = optional(string)
      auth_authentication_request_extra_param_map = optional(map(string))
      auth_cognito_client_app_key                 = optional(string)
      auth_cognito_pool_key                       = optional(string)
      auth_oidc_authorization_endpoint            = optional(string)
      auth_oidc_client_id                         = optional(string)
      auth_oidc_client_secret                     = optional(string)
      auth_oidc_issuer                            = optional(string)
      auth_oidc_token_endpoint                    = optional(string)
      auth_oidc_user_info_endpoint                = optional(string)
      auth_on_unauthenticated_request             = optional(string)
      auth_scope_list                             = optional(list(string))
      auth_session_cookie_name                    = optional(string)
      auth_session_timeout_seconds                = optional(number)
    })))
    alert_enabled                       = optional(bool)
    auto_scaling_num_instances_max      = optional(number)
    auto_scaling_num_instances_min      = optional(number)
    blue_green_termination_wait_minutes = optional(number)
    blue_green_timeout_wait_minutes     = optional(number)
    build_artifact_name                 = optional(string)
    build_data_key                      = optional(string)
    build_role_policy_attach_arn_map    = optional(map(string))
    build_role_policy_create_json_map   = optional(map(string))
    build_role_policy_inline_json_map   = optional(map(string))
    build_role_policy_managed_name_map  = optional(map(string))
    build_stage_list = list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_build_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_build_project_key       = optional(string) # Must provide a config or project key
        configuration_deploy_application_name = optional(string) # Must provide all or none for deploy
        configuration_deploy_group_name       = optional(string)
        input_artifact_list                   = optional(list(string))
        # namespace is always StageNameActionKey
        output_artifact      = optional(string) # simply combined with list below
        output_artifact_list = optional(list(string))
        owner                = optional(string)
        provider             = optional(string)
        version              = optional(string)
      }))
      name = string
    }))
    container_definition_map = map(object({
      command_join          = optional(bool)
      command_list          = optional(list(string))
      environment_file_list = optional(list(string))
      environment_map       = optional(map(string))
      entry_point           = optional(list(string))
      image                 = optional(string) # Will be defaulted if image_ecr_repo_create
      mount_point_map = optional(map(object({
        container_path = string
        read_only      = optional(bool)
      })))
      port_map = optional(map(object({
        host_port = optional(number) # Defaults to container port (key)
        protocol  = optional(string)
      })))
      privileged          = optional(bool)
      reserved_memory_gib = optional(number)
      reserved_num_vcpu   = optional(number)
      secret_map          = optional(map(string))
      username            = optional(string)
    }))
    deployment_controller_type      = optional(string)
    deployment_style_use_blue_green = optional(bool)
    desired_count                   = optional(number)
    dns_alias_enabled               = optional(bool)
    dns_from_zone_key               = optional(string)
    docker_volume_map = optional(map(object({
      auto_provision_enabled = optional(bool)
      driver                 = optional(string)
      driver_option_map      = optional(map(string))
      label_map              = optional(map(string))
      scope                  = optional(string)
    })))
    efs_volume_map = optional(map(object({
      authorization_access_point_id = optional(string)
      authorization_iam_enabled     = optional(bool)
      file_system_id                = string
      root_directory                = optional(string)
      transit_encryption_enabled    = optional(bool)
      transit_encryption_port       = optional(string)
    })))
    elb_health_check_grace_period_seconds = optional(number)
    elb_target_map = optional(map(object({
      acm_certificate_key = optional(string)
      container_name      = optional(string)
      container_port      = optional(number)
      listen_port         = optional(number) # Defaults to prod/test ports
      rule_condition_map = optional(map(object({
        host_header_pattern_list = optional(list(string))
        http_header_map = optional(map(object({
          pattern_list = list(string)
        })))
        http_request_method_list = optional(list(string))
        path_pattern_list        = optional(list(string))
        query_string_map = optional(map(object({
          key_pattern   = optional(string)
          value_pattern = string
        })))
        source_ip_list = optional(list(string))
      })))
      rule_priority = optional(number)
    })))
    elb_key                           = optional(string)
    health_check_http_path            = optional(string)
    iam_role_arn_execution            = optional(string)
    image_build_arch_list             = optional(list(string))
    image_ecr_repo_key                = optional(string)
    image_environment_key_arch        = optional(string)
    image_environment_key_tag         = optional(string)
    image_id                          = optional(string) # This is for the AMI
    image_tag_base                    = optional(string)
    instance_storage_gib              = optional(number)
    instance_type                     = optional(string)
    key_pair_key                      = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    path_include_env                  = optional(bool)
    path_repo_root_to_spec_directory  = optional(string)
    path_terraform_app_to_repo_root   = optional(string)
    provider_instance_warmup_period_s = optional(number)
    resource_memory_gib               = optional(number)
    resource_num_vcpu                 = optional(string)
    role_policy_attach_arn_map        = optional(map(string))
    role_policy_create_json_map       = optional(map(string))
    role_policy_inline_json_map       = optional(map(string))
    role_policy_managed_name_map      = optional(map(string))
    sticky_cookie_enabled             = optional(bool)
    source_branch                     = optional(string)
    source_build_spec_image           = optional(string)
    source_build_spec_manifest        = optional(string)
    source_code_star_connection_key   = optional(string)
    source_detect_changes             = optional(bool)
    source_repository_id              = optional(string)
    target_protocol_http_version      = optional(string)
    trigger_map = optional(map(object({
      event_list    = optional(list(string))
      sns_topic_arn = optional(string)
    })))
    vpc_az_key_list                      = optional(list(string))
    vpc_key                              = optional(string)
    vpc_security_group_key_list          = optional(list(string))
    vpc_security_group_key_list_instance = optional(list(string))
    vpc_segment_key                      = optional(string)
  }))
}

variable "app_deployment_listen_port_prod_default" {
  type    = number
  default = 443
}

variable "app_deployment_listen_port_test_default" {
  type    = number
  default = 8443
}

variable "app_path_include_env_default" {
  type    = bool
  default = true
}

variable "app_path_repo_root_to_spec_directory_default" {
  type    = string
  default = null
}

variable "app_path_terraform_app_to_repo_root_default" {
  type    = string
  default = null
}

variable "build_image_build_arch_list_default" {
  type = list(string)
  default = [
    "amd",
    "arm",
  ]
}

variable "build_image_ecr_repo_key_default" {
  type    = string
  default = null
}

variable "build_image_environment_key_arch_default" {
  type    = string
  default = "ARCH"
}

variable "build_image_environment_key_tag_default" {
  type    = string
  default = "TAG"
}

variable "build_image_tag_base_default" {
  type        = string
  default     = "latest"
  description = "The tag of the final manifest. Each arch-specific image tag will have the arch appended"
}

variable "build_role_policy_attach_arn_map_default" {
  type        = map(string)
  default     = {}
  description = "The special sauce for the role; log write and artifact read/write come free"
}

variable "build_role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "build_role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "build_role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "build_source_build_spec_image_default" {
  type    = string
  default = null
}

variable "build_source_build_spec_manifest_default" {
  type    = string
  default = null
}

variable "build_vpc_access_default" {
  type    = bool
  default = true
}

variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
      policy = object({
        iam_policy_arn_map = map(string)
      })
    })
    code_star = object({
      connection = map(object({
        connection_arn     = string
        iam_policy_arn_map = map(string)
      }))
    })
    log = object({
      iam_policy_arn_map = map(string)
      log_group_name     = string
    })
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
    role = object({
      build = object({
        basic = object({
          iam_role_arn = string
        })
      })
      deploy = object({
        ecs = object({
          iam_role_arn = string
        })
      })
    })
  })
}

variable "ci_cd_build_data_map" {
  type = map(object({
    build_map = map(object({
      name_effective = string
    }))
  }))
}

variable "cognito_data_map" {
  type = map(object({
    user_pool_arn = string
    user_pool_client = object({
      client_app_map = map(object({
        client_app_id = string
      }))
    })
    user_pool_fqdn = string
  }))
  default     = {}
  description = "Must be provided if any action uses a Cognito authorizer"
}

variable "compute_auto_scaling_num_instances_max_default" {
  type    = number
  default = 1
}

variable "compute_auto_scaling_num_instances_min_default" {
  type    = number
  default = 0
}

variable "compute_image_id_default" {
  type    = string
  default = null
}

variable "compute_instance_storage_gib_default" {
  type    = number
  default = 30
}

variable "compute_instance_type_default" {
  type    = string
  default = "t4g.nano"
}

variable "compute_key_pair_key_default" {
  type    = string
  default = null
}

variable "compute_provider_instance_warmup_period_s_default" {
  type    = number
  default = 300
}

variable "deployment_blue_green_termination_wait_minutes_default" {
  type        = number
  default     = 0
  description = "Ignored unless terminate_on_success is true. No other deployment can commence during this wait."
}

variable "deployment_blue_green_timeout_wait_minutes_default" {
  type        = number
  default     = 5
  description = "Ignored unless timeout action is STOP_DEPLOYMENT"
}

variable "deployment_style_use_blue_green_default" {
  type        = bool
  default     = true
  description = "If true a target group and load balancer must be provided. Ignored if a custom elb_target_map is provided with more than one target or deployment controller is not CODE_DEPLOY: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/register-multiple-targetgroups.html"
}

variable "deployment_trigger_map_default" {
  type = map(object({
    event_list    = optional(list(string))
    sns_topic_arn = optional(string)
  }))
  default = {}
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    domain_to_sd_zone_map = map(object({
      id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
      name_simple     = string
    })))
  })
}

variable "ecr_data_map" {
  type = map(object({
    iam_policy_arn_map = object({
      read_write = string
    })
    repo_url = string
  }))
  default     = null
  description = "Must be provided if any app enables image build"
}

variable "elb_data_map" {
  type = map(object({
    elb_arn            = string
    elb_dns_name       = string
    elb_dns_zone_id    = string
    load_balancer_type = string
    port_to_protocol_to_listener_map = map(map(object({
      elb_listener_arn = string
    })))
  }))
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs    = string
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_role_arn_ecs_task_execution = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
}

variable "listener_acm_certificate_key_default" {
  type        = string
  default     = null
  description = "Must be provided if a listener uses HTTPS"
}

variable "app_action_order_default_forward_default" {
  type    = number
  default = 40000
}

variable "listener_action_map_default" {
  type = map(object({
    action_fixed_response_content_type         = optional(string)
    action_fixed_response_message_body         = optional(string)
    action_fixed_response_status_code          = optional(number)
    action_forward_stickiness_duration_seconds = optional(number)
    action_forward_stickiness_enabled          = optional(bool)
    action_forward_target_group_map = optional(map(object({
      target_group_weight = optional(number)
    })))
    action_order                                = optional(number)
    action_redirect_host                        = optional(string)
    action_redirect_path                        = optional(string)
    action_redirect_port                        = optional(number)
    action_redirect_protocol                    = optional(string)
    action_redirect_query                       = optional(string)
    action_redirect_status_code                 = optional(string)
    action_type                                 = optional(string)
    auth_authentication_request_extra_param_map = optional(map(string))
    auth_cognito_client_app_key                 = optional(string)
    auth_cognito_pool_key                       = optional(string)
    auth_oidc_authorization_endpoint            = optional(string)
    auth_oidc_client_id                         = optional(string)
    auth_oidc_client_secret                     = optional(string)
    auth_oidc_issuer                            = optional(string)
    auth_oidc_token_endpoint                    = optional(string)
    auth_oidc_user_info_endpoint                = optional(string)
    auth_on_unauthenticated_request             = optional(string)
    auth_scope_list                             = optional(list(string))
    auth_session_cookie_name                    = optional(string)
    auth_session_timeout_seconds                = optional(number)
  }))
  default     = {}
  description = "This will be merged with a default forward rule at priority app_action_order_default_forward"
}

variable "listener_action_fixed_response_content_type_default" {
  type    = string
  default = "application/json"
  validation {
    condition     = contains(["application/javascript", "application/json", "text/css", "text/html", "text/plain"], var.listener_action_fixed_response_content_type_default)
    error_message = "Invalid action_fixed_response_content_type"
  }
}

variable "listener_action_fixed_response_message_body_default" {
  type    = string
  default = null
}

variable "listener_action_fixed_response_status_code_default" {
  type    = number
  default = 200
  validation {
    condition     = var.listener_action_fixed_response_status_code_default >= 200 && var.listener_action_fixed_response_status_code_default <= 599
    error_message = "Invalid status code"
  }
}

variable "listener_action_forward_stickiness_duration_seconds_default" {
  type    = number
  default = 60 * 60
  validation {
    condition     = var.listener_action_forward_stickiness_duration_seconds_default >= 1 && var.listener_action_forward_stickiness_duration_seconds_default <= 60 * 60 * 24 * 7
    error_message = "Invalid stickiness duration"
  }
}

variable "listener_action_forward_stickiness_enabled_default" {
  type    = bool
  default = false
}

variable "listener_action_order_default" {
  type    = number
  default = 10000
  validation {
    condition     = var.listener_action_order_default >= 1 && var.listener_action_order_default <= 50000
    error_message = "Invalid action order"
  }
}

variable "listener_action_redirect_host_default" {
  type    = string
  default = "#{host}"
}

variable "listener_action_redirect_path_default" {
  type    = string
  default = "#{path}"
}

variable "listener_action_redirect_port_default" {
  type        = number
  default     = null
  description = "Defaults to #{port}"
}

variable "listener_action_redirect_protocol_default" {
  type    = string
  default = "#{protocol}"
  validation {
    condition     = contains(["HTTP", "HTTPS", "#{protocol}"], var.listener_action_redirect_protocol_default)
    error_message = "Invalid action_redirect_protocol"
  }
}

variable "listener_action_redirect_query_default" {
  type    = string
  default = "#{query}"
}

variable "listener_action_redirect_status_code_default" {
  type    = string
  default = "HTTP_301"
  validation {
    condition     = contains(["HTTP_301", "HTTP_302"], var.listener_action_redirect_status_code_default)
    error_message = "Invalid action_redirect_status_code"
  }
}

variable "listener_action_type_default" {
  type    = string
  default = null
  validation {
    condition     = var.listener_action_type_default == null ? true : contains(["authenticate-cognito", "authenticate-oidc", "fixed-response", "forward", "redirect"], var.listener_action_type_default)
    error_message = "Invalid action_type"
  }
}

variable "listener_auth_authentication_request_extra_param_map_default" {
  type        = map(string)
  default     = {}
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_cognito_client_app_key_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_cognito_pool_key_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_oidc_authorization_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_client_id_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_client_secret_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_issuer_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_token_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_user_info_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_on_unauthenticated_request_default" {
  type        = string
  default     = "deny"
  description = "Ignored unless action_type is authenticate. Authenticate involves a 302 redirect."
  validation {
    condition     = var.listener_auth_on_unauthenticated_request_default == null ? true : contains(["allow", "authenticate", "deny"], var.listener_auth_on_unauthenticated_request_default)
    error_message = "Invalid auth_on_unauthenticated_request"
  }
}

variable "listener_auth_scope_list_default" {
  type        = list(string)
  default     = ["email", "openid"]
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_session_cookie_name_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_session_timeout_seconds_default" {
  type        = number
  default     = 60 * 60 * 24
  description = "Ignored unless action_type is authenticate"
}

variable "listener_dns_alias_enabled_default" {
  type    = bool
  default = true
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_key_default" {
  type    = string
  default = null
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
    ecs_ssm_param_map = object({
      cpu = object({
        name_effective = string
      })
      gpu = object({
        name_effective = string
      })
    })
  })
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "pipe_build_artifact_name_default" {
  type        = string
  default     = null
  description = "The name of the artifact that contains the site directory to sync"
}

variable "pipe_build_data_key_default" {
  type        = string
  default     = null
  description = "Defaults to map key"
}

variable "pipe_source_branch_default" {
  type    = string
  default = "main"
}

variable "pipe_source_code_star_connection_key_default" {
  type    = string
  default = null
}

variable "pipe_source_detect_changes_default" {
  type    = bool
  default = true
}

variable "pipe_source_repository_id_default" {
  type    = string
  default = null
}

variable "pipe_webhook_enable_github_hook_default" {
  type        = bool
  default     = true
  description = "Ignored if webhook is not enabled"
}

variable "pipe_webhook_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
}

variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type    = map(string)
  default = {}
}

variable "rule_condition_map_default" {
  type = map(object({
    host_header_pattern_list = optional(list(string))
    http_header_map = optional(map(object({
      pattern_list = list(string)
    })))
    http_request_method_list = optional(list(string))
    path_pattern_list        = optional(list(string))
    query_string_map = optional(map(object({
      key_pattern   = optional(string)
      value_pattern = string
    })))
    source_ip_list = optional(list(string))
  }))
  default = {}
}

variable "rule_host_header_pattern_list_default" {
  type        = list(string)
  default     = []
  description = "Defaults to fqdn for cert if no other condition is specified"
}

variable "rule_http_header_map_default" {
  type = map(object({
    pattern_list = list(string)
  }))
  default     = {}
  description = "A map of header name to value matchers"
}

variable "rule_http_request_method_list_default" {
  type    = list(string)
  default = []
}

variable "rule_path_pattern_list_default" {
  type    = list(string)
  default = []
}

variable "rule_priority_default" {
  type        = number
  default     = null
  description = "defaults to order in the list"
  validation {
    condition     = var.rule_priority_default == null ? true : var.rule_priority_default >= 1 && var.rule_priority_default <= 50000
    error_message = "Invalid action order"
  }
}

variable "rule_query_string_map_default" {
  type = map(object({
    key_pattern   = optional(string)
    value_pattern = string
  }))
  default = {}
}

variable "rule_source_ip_list_default" {
  type    = list(string)
  default = []
}

variable "rule_listener_key_default" {
  type        = string
  default     = null
  description = "Ignored if no condition is set"
}

variable "service_deployment_controller_type_default" {
  type        = string
  default     = "CODE_DEPLOY"
  description = "Ignored if more than one ELB target is specified"
  validation {
    condition     = contains(["CODE_DEPLOY", "ECS", "EXTERNAL"], var.service_deployment_controller_type_default)
    error_message = "Invalid deployment controller type"
  }
}

variable "service_desired_count_default" {
  type        = number
  default     = 1
  description = "Ignored for DAEMON scheduling strategy"
}

variable "service_elb_health_check_grace_period_seconds_default" {
  type        = number
  default     = 300
  description = "Ignored unless attached to at least one target group"
}

variable "service_elb_target_map_default" {
  type = map(object({
    acm_certificate_key = optional(string)
    container_name      = optional(string)
    container_port      = optional(number)
    listen_port         = optional(number)
    rule_condition_map = optional(map(object({
      host_header_pattern_list = optional(list(string))
      http_header_map = optional(map(object({
        pattern_list = list(string)
      })))
      http_request_method_list = optional(list(string))
      path_pattern_list        = optional(list(string))
      query_string_map = optional(map(object({
        key_pattern   = optional(string)
        value_pattern = string
      })))
      source_ip_list = optional(list(string))
    })))
    rule_priority = optional(number)
  }))
  default     = null
  description = "Map of target group key to container port. More than one target disables blue-green deployments. Defaults to blue target with all default attributes injected."
}

variable "service_elb_target_container_name_default" {
  type        = string
  default     = null
  description = "Every service attached to an ELB must provide an ELB container name or a container map with a single container"
}

variable "service_elb_target_container_port_default" {
  type    = number
  default = 80
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "target_health_check_http_path_default" {
  type    = string
  default = "/health"
}

variable "target_protocol_http_version_default" {
  type    = string
  default = "HTTP1"
  validation {
    condition     = contains(["GRPC", "HTTP1", "HTTP2"], var.target_protocol_http_version_default)
    error_message = "Invalid target protocol version"
  }
}

variable "target_sticky_cookie_enabled_default" {
  type    = bool
  default = false
}

variable "task_container_command_join_default" {
  type    = bool
  default = true
}

variable "task_container_entry_point_default" {
  type        = list(string)
  default     = null
  description = "These are typically specified in the Dockerfile for services"
}

variable "task_container_environment_file_list_default" {
  type    = list(string)
  default = []
}

variable "task_container_environment_map_default" {
  type    = map(string)
  default = {}
}

variable "task_container_image_default" {
  type    = string
  default = "public.ecr.aws/lts/ubuntu:latest"
}

variable "task_container_mount_point_map_default" {
  type = map(object({
    container_path = string
    read_only      = optional(bool)
  }))
  default = {}
}

variable "task_container_mount_read_only_default" {
  type    = bool
  default = false
}

variable "task_container_port_map_default" {
  type = map(object({
    host_port = optional(number) # Defaults to container port (key)
    protocol  = optional(string)
  }))
  default = {
    80 = {
      host_port = null
      protocol  = null
    }
  }
}

variable "task_container_port_protocol_default" {
  type    = string
  default = "tcp"
  validation {
    condition     = contains(["tcp", "udp"], var.task_container_port_protocol_default)
    error_message = "Invalid protocol"
  }
}

variable "task_container_privileged_default" {
  type    = bool
  default = false
}

variable "task_container_read_only_root_file_system_default" {
  type        = bool
  default     = true
  description = "A critical severity finding if false"
}

variable "task_container_reserved_memory_gib_default" {
  type        = number
  default     = null
  description = "Defaults to task memory evenly divided between containers"
}

variable "task_container_reserved_num_vcpu_default" {
  type        = number
  default     = null
  description = "Defaults to CPU units for the task divided evenly by tasks"
}

variable "task_container_secret_map_default" {
  type    = map(string)
  default = {}
}

variable "task_container_username_default" {
  type    = string
  default = "ubuntu"
}

variable "task_docker_volume_map_default" {
  type = map(object({
    auto_provision_enabled = optional(bool)
    driver                 = optional(string)
    driver_option_map      = optional(map(string))
    label_map              = optional(map(string))
    scope                  = optional(string)
  }))
  default = {}
}

variable "task_docker_volume_auto_provision_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless scope is shared"
}

variable "task_docker_volume_driver_default" {
  type    = string
  default = "local"
}

variable "task_docker_volume_driver_option_map_default" {
  type    = map(string)
  default = {}
}

variable "task_docker_volume_label_map_default" {
  type    = map(string)
  default = {}
}

variable "task_docker_volume_scope_default" {
  type    = string
  default = "task"
}

variable "task_efs_volume_map_default" {
  type = map(object({
    authorization_access_point_id = optional(string)
    authorization_iam_enabled     = optional(bool)
    file_system_id                = string
    root_directory                = optional(string)
    transit_encryption_enabled    = optional(bool)
    transit_encryption_port       = optional(number)
  }))
  default = {}
}

variable "task_iam_role_arn_execution_default" {
  type        = string
  default     = null
  description = "By default, the task execution role is the basic role from IAM data. This overrides the default."
}

variable "task_resource_memory_gib_default" {
  type        = number
  default     = null
  description = "Required for Fargate, for EC2 defaults to instance_type_memory_gib - task_memory_host_gib_default"
}

variable "task_resource_num_vcpu_default" {
  type        = number
  default     = null
  description = "Required for Fargate, for EC2 defaults to number of CPUs for the instance x 1024"
}

variable "use_fargate" {
  type    = bool
  default = false
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_http_in",
    "world_all_out",
  ]
  description = "Security groups for the service"
}

variable "vpc_security_group_key_list_instance_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
  description = "Security groups for cluster instances and build projects"
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
