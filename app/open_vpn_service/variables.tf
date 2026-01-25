variable "app_path_repo_root_to_app_directory_default" {
  type    = string
  default = null
}

variable "app_path_terraform_app_to_repo_root_default" {
  type    = string
  default = null
}

variable "build_image_ecr_repo_key_default" {
  type    = string
  default = null
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

variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
      policy = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
    code_star = object({
      connection = map(object({
        connection_arn = string
        policy_map = map(object({
          iam_policy_arn = string
        }))
      }))
    })
    log = object({
      log_group_name = string
      policy_map = map(object({
        iam_policy_arn = string
      }))
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

variable "compute_instance_type_default" {
  type    = string
  default = "t4g.micro"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    domain_to_sd_zone_map = map(object({
      namespace_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
      name_simple     = string
    })))
  })
}

variable "ecr_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
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
    iam_instance_profile_arn_ecs        = string
    iam_policy_arn_batch_submit_job     = string
    iam_policy_arn_ec2_modify_attribute = string
    iam_policy_arn_ecs_exec_ssm         = string
    iam_policy_arn_ecs_start_task       = string
    iam_policy_arn_ecs_task_execution   = string
    iam_role_arn_ecs_task_execution     = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_dns_alias_enabled_default" {
  type    = bool
  default = true
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
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
      gpu = object({
        name_effective = string
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
  })
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
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

variable "pipe_webhook_enabled_default" {
  type    = bool
  default = false
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
    policy = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
  }))
}

variable "secret_is_param_default" {
  type    = bool
  default = false
}

variable "secret_random_init_key_default" {
  type        = string
  default     = "admin_password"
  description = "If provided, the initial value with be a map with the random secret at this key, otherwise the initial value will be the secret itself. Ignored for TLS keys."
}

variable "secret_random_init_map_default" {
  type = map(string)
  default = {
    admin_username           = "openvpn"
    license_key              = "INSERT LICENSE KEY HERE"
    license_website_password = "INSERT WEBSITE PASSWORD"
    license_website_url      = "https://myaccount.openvpn.com"
    license_website_username = "INSERT WEBSITE USERNAME"
  }
  description = "If provided, will be merged with the secret key, if provided"
}

variable "secret_random_init_value_map" {
  type        = map(string)
  description = "For each secret, if an initial value is provided, the secret will be initialized with that value, otherwise a random password."
  default     = {}
}

variable "secret_random_special_character_set_default" {
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?"
  description = "Has no effect unless a secret is a password"
}

variable "service_desired_count_default" {
  type        = number
  default     = 1
  description = "Ignored for DAEMON scheduling strategy"
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

variable "vpc_az_key_list_default" {
  type = list(string)
  default = [
    "a",
    "b",
  ]
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}

variable "vpc_security_group_key_list_efs_default" {
  type = list(string)
  default = [
    "internal_nfs_in",
    "world_all_out",
  ]
}

variable "vpc_security_group_key_list_instance_default" {
  type = list(string)
  default = [
    "internal_http_in",
    "internal_open_vpn_in",
    "world_all_out",
    "world_icmp_in",
  ]
}

variable "vpn_backup_bucket_key_default" {
  type    = string
  default = null
}

variable "vpn_elb_key_alb_default" {
  type    = string
  default = null
}

variable "vpn_elb_key_nlb_default" {
  type    = string
  default = null
}

variable "vpn_image_source_uri_default" {
  type    = string
  default = null
}

variable "vpn_map" {
  type = map(object({
    backup_bucket_key                  = optional(string)
    build_role_policy_attach_arn_map   = optional(map(string))
    build_role_policy_create_json_map  = optional(map(string))
    build_role_policy_inline_json_map  = optional(map(string))
    build_role_policy_managed_name_map = optional(map(string))
    desired_count                      = optional(number)
    dns_alias_enabled                  = optional(bool)
    dns_alias_fqdn_admin               = optional(string) # Defaults to vpn-admin.${from_zone_key}
    dns_alias_fqdn_tunnel              = optional(string) # Defaults to vpn.${from_zone_key}
    dns_from_zone_key                  = optional(string)
    elb_key_alb                        = optional(string)
    elb_key_nlb                        = optional(string)
    elb_rule_priority_alb              = number
    image_ecr_repo_key                 = optional(string)
    image_source_uri                   = optional(string)
    image_tag_base                     = optional(string)
    instance_type                      = optional(string)
    name_append                        = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
    name_prefix                        = optional(string)
    name_prepend                       = optional(string)
    name_suffix                        = optional(string)
    path_repo_root_to_app_directory    = optional(string)
    path_terraform_app_to_repo_root    = optional(string)
    secret_is_param                    = optional(bool)
    secret_random_init_key             = optional(string)
    secret_random_init_map             = optional(map(string))
    source_branch                      = optional(string)
    source_repository_id               = optional(string)
    vpc_az_key_list                    = optional(list(string))
    vpc_key                            = optional(string)
    vpc_security_group_key_list        = optional(list(string))
    vpc_segment_key                    = optional(string)
  }))
}
