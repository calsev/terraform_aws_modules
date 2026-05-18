variable "endpoint_map_custom_default" {
  type = map(object({
    add_region_name      = optional(bool)
    auto_accept_enabled  = optional(bool)
    dns_record_ip_type   = optional(string)
    endpoint_segment_key = optional(string)
    endpoint_subnet_map = optional(map(object({
      # Optional addresses, for Gateway endpoints only
      ipv4_address = optional(string)
      ipv6_address = optional(string)
    })), {})
    endpoint_type                                  = optional(string)
    iam_policy_json                                = optional(string)
    ip_address_type                                = optional(string)
    name_append                                    = optional(string)
    name_include_app_fields                        = optional(bool)
    name_infix                                     = optional(bool)
    name_prefix                                    = optional(string)
    name_prepend                                   = optional(string)
    name_suffix                                    = optional(string)
    private_dns_enabled                            = optional(bool)
    private_dns_for_inbound_resolver_endpoint_only = optional(bool)
    service_name_override                          = optional(string)
    service_name_short                             = optional(string)
    vpc_security_group_key_list                    = optional(list(string))
  }))
  default = {
  }
  description = "These endpoints are merged with standard defaults"
}

variable "endpoint_map_standard_default" {
  type = map(object({
    add_region_name      = optional(bool)
    auto_accept_enabled  = optional(bool)
    dns_record_ip_type   = optional(string)
    endpoint_segment_key = optional(string)
    endpoint_subnet_map = optional(map(object({
      # Optional addresses, for Gateway endpoints only
      ipv4_address = optional(string)
      ipv6_address = optional(string)
    })), {})
    endpoint_type                                  = optional(string)
    iam_policy_json                                = optional(string)
    ip_address_type                                = optional(string)
    name_append                                    = optional(string)
    name_include_app_fields                        = optional(bool)
    name_infix                                     = optional(bool)
    name_prefix                                    = optional(string)
    name_prepend                                   = optional(string)
    name_suffix                                    = optional(string)
    private_dns_enabled                            = optional(bool)
    private_dns_for_inbound_resolver_endpoint_only = optional(bool)
    service_name_override                          = optional(string)
    service_name_short                             = optional(string)
    vpc_security_group_key_list                    = optional(list(string))
  }))
  default = {
    ec2 = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "ipv4"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
    "ecr.api" = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "ipv4"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
    "ecr.dkr" = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "ipv4"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
    ssm = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "ipv4"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
    ssm-contacts = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "dualstack"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
    ssm-incidents = {
      add_region_name                                = null
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "dualstack"
      name_append                                    = null
      name_include_app_fields                        = null
      name_infix                                     = null
      name_prefix                                    = null
      name_prepend                                   = null
      name_suffix                                    = null
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
  }
  description = "These endpoints are required to avoid security violations, and are merged with custom defaults"
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs        = string
    iam_policy_arn_batch_submit_job     = string
    iam_policy_arn_ec2_associate_eip    = string
    iam_policy_arn_ec2_modify_attribute = string
    iam_policy_arn_ecr_get_token        = string
    iam_policy_arn_ecs_exec_ssm         = string
    iam_policy_arn_ecs_start_task       = string
    iam_policy_arn_ecs_task_execution   = string
    iam_policy_arn_lambda_vpc           = string
    iam_role_arn_backup_create          = string
    iam_role_arn_batch_service          = string
    iam_role_arn_batch_spot_fleet       = string
    iam_role_arn_ecs_task_execution     = string
    iam_role_arn_rds_monitor            = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
  default     = null
  description = "Must be provided if using a nat instance"
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        topic_arn = string
      }))
    })
    ecs_ssm_param_map = object({
      cpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
      gpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
    })
  })
  default     = null
  description = "Must be provided if using a nat instance"
}

variable "s3_data_map" {
  type = map(object({
    bucket_arn = string
  }))
  default     = null
  description = "Must be provided if a log bucket key is specified"
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

variable "vpc_map" {
  type = map(object({
    # Subnets can be added after creation, but not segments
    availability_zone_map_key_list = optional(list(string))
    endpoint_map = optional(map(object({
      auto_accept_enabled  = optional(bool)
      dns_record_ip_type   = optional(string)
      endpoint_segment_key = optional(string)
      endpoint_subnet_map = optional(map(object({
        ipv4_address = optional(string) # Optional, ignored except for Gateway endpoints
        ipv6_address = optional(string) # Optional, ignored except for Gateway endpoints
      })), {})
      endpoint_type                                  = optional(string)
      iam_policy_json                                = optional(string)
      ip_address_type                                = optional(string)
      name_append                                    = optional(string)
      name_include_app_fields                        = optional(bool)
      name_infix                                     = optional(bool)
      name_prefix                                    = optional(string)
      name_prepend                                   = optional(string)
      name_suffix                                    = optional(string)
      private_dns_enabled                            = optional(bool)
      private_dns_for_inbound_resolver_endpoint_only = optional(bool)
      service_name_override                          = optional(string)
      service_name_short                             = optional(string)
      vpc_security_group_key_list                    = optional(list(string))
    })))
    nat_gateway_enabled = optional(bool)
    nat_multi_az        = optional(bool)
    peer_map = optional(map(object({ # Key can be a VPC key or VPC ID
    })))
    segment_map = optional(map(object({
      route_internal = optional(bool)
      route_public   = optional(bool)
    })))
    subnet_bit_length                   = optional(number) # The number of bits to add to the mask, defaults to ceil(log(#segments * #azs, 2)), set higher to accommodate future AZs
    vpc_cidr_block                      = string
    vpc_flow_log_destination_bucket_key = optional(string)
  }))
}

variable "vpc_availability_zone_map_key_list_default" {
  type        = list(string)
  default     = ["a", "b"]
  description = "AZs a, ... will be created for each key, mapped to these AWS AZs"
}

variable "vpc_flow_log_destination_bucket_key_default" {
  type        = string
  default     = null
  description = "If true, flow logs will be enabled for the VPC"
}

variable "vpc_nat_multi_az_default" {
  type        = bool
  default     = true
  description = "If false, a single NAT will be created"
}
