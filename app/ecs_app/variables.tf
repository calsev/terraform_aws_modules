variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "app_map" {
  type = map(object({
    acm_certificate_key = optional(string)
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
      auth_cognito_user_pool_arn                  = optional(string)
      auth_cognito_user_pool_client_app_id        = optional(string)
      auth_cognito_user_pool_fqdn                 = optional(string)
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
    build_stage_list = list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_build_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_build_project_name      = optional(string) # Must provide a config or project name
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
    container_definition_list = list(object({
      command_join          = optional(bool)
      command_list          = optional(list(string))
      environment_file_list = optional(list(string))
      environment_map       = optional(map(string))
      entry_point           = optional(list(string))
      image                 = optional(string)
      name                  = string
      mount_point_map = optional(map(object({
        container_path = string
        read_only      = optional(bool)
      })))
      port_map_list = optional(list(object({
        container_port = number
        host_port      = optional(number)
        protocol       = optional(string)
      })))
      reserved_memory_gib = optional(number)
      reserved_num_vcpu   = optional(number)
      secret_map          = optional(map(string))
    }))
    deployment_style_use_blue_green       = optional(bool)
    desired_count                         = optional(number)
    dns_from_zone_key                     = optional(string)
    elb_container_name                    = optional(string)
    elb_container_port                    = optional(number)
    elb_health_check_grace_period_seconds = optional(number)
    elb_key                               = optional(string)
    health_check_http_path                = optional(string)
    image_id                              = optional(string)
    instance_storage_gib                  = optional(number)
    instance_type                         = optional(string)
    name_include_app_fields               = optional(bool)
    name_infix                            = optional(bool)
    path_include_env                      = optional(bool)
    path_repo_root_to_spec_directory      = optional(string)
    path_terraform_app_to_repo_root       = optional(string)
    provider_instance_warmup_period_s     = optional(number)
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
    rule_priority                   = optional(number)
    sticky_cookie_enabled           = optional(bool)
    source_branch                   = optional(string)
    source_code_star_connection_key = optional(string)
    source_repository_id            = optional(string)
    target_protocol_http_version    = optional(string)
    trigger_map = optional(map(object({
      event_list    = optional(list(string))
      sns_topic_arn = optional(string)
    })))
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      iam_policy_arn_map = map(string)
      name_effective     = string
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
  description = "If true a target group and load balancer must be provided"
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

variable "elb_data_map" {
  type = map(object({
    elb_arn         = string
    elb_dns_name    = string
    elb_dns_zone_id = string
    protocol_to_port_to_listener_map = map(map(object({
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
    auth_cognito_user_pool_arn                  = optional(string)
    auth_cognito_user_pool_client_app_id        = optional(string)
    auth_cognito_user_pool_fqdn                 = optional(string)
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
  description = "This will be merged with a default forward rule at priority 40000"
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
  default = 60
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

variable "listener_auth_cognito_user_pool_arn_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_cognito_user_pool_client_app_id_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_cognito_user_pool_fqdn_default" {
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
  default     = null # TODO: ?
  description = "Ignored unless action_type is authenticate"
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
  default     = null
  description = "Ignored unless action_type is authenticate"
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

variable "pipe_source_branch_default" {
  type    = string
  default = "main"
}

variable "pipe_source_code_star_connection_key_default" {
  type    = string
  default = null
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
  type    = list(string)
  default = []
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

variable "service_desired_count_default" {
  type        = number
  default     = 1
  description = "Ignored for DAEMON scheduling strategy"
}

variable "service_elb_container_name_default" {
  type    = string
  default = null
}

variable "service_elb_container_port_default" {
  type    = number
  default = 80
}

variable "service_elb_health_check_grace_period_seconds_default" {
  type        = number
  default     = 300
  description = "Ignored unless attached to at least one target group"
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
  type    = list(string)
  default = ["/usr/bin/bash", "-cex"]
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

variable "task_container_mount_read_only_default" {
  type    = bool
  default = false
}

variable "task_container_port_protocol_default" {
  type    = string
  default = "tcp"
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
    vpc_id = string
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
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}