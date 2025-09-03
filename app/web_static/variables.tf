variable "bucket_log_target_bucket_name_default" {
  type    = string
  default = null
}

variable "bucket_website_error_document_default" {
  type    = string
  default = "error.html"
}

variable "bucket_website_index_document_default" {
  type    = string
  default = "index.html"
}

variable "build_environment_type_default" {
  type    = string
  default = "cpu-arm-amazon-small"
}

variable "cdn_global_data" {
  type = object({
    cache_policy_map = map(object({
      policy_id = string
    }))
    domain_cert_map = map(object({
      certificate_arn = string
    }))
    origin_request_policy_map = map(object({
      policy_id = string
    }))
    web_acl_map = map(object({
      waf_acl_arn = string
    }))
  })
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
      policy_map = map(object({
        iam_policy_arn = string
      }))
      log_group_name = string
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

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "domain_dns_alias_enabled_default" {
  type    = bool
  default = true
}

variable "domain_dns_alias_san_list_default" {
  type        = list(string)
  default     = []
  description = "Subject alternate names on the DNS certficate to add as aliases. Ignored if DNS alias not enabled."
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_logging_bucket_key_default" {
  type    = string
  default = null
}

variable "domain_logging_include_cookies_default" {
  type    = bool
  default = false
}

variable "domain_logging_object_prefix_default" {
  type    = string
  default = ""
}

variable "domain_origin_dns_enabled_default" {
  type    = bool
  default = true
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

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "site_map" {
  type = map(object({
    build_artifact_name      = optional(string)
    build_artifact_sync_path = optional(string) # The local root path to sync to S3 bucket root
    build_environment_type   = optional(string)
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
    cdn_invalidation_path                                 = optional(string)
    ci_cd_pipeline_webhook_secret_is_param                = optional(bool)
    dns_alias_enabled                                     = optional(bool)
    dns_alias_san_list                                    = optional(list(string))
    dns_from_zone_key                                     = optional(string)
    logging_bucket_key                                    = optional(string)
    logging_include_cookies                               = optional(bool)
    logging_object_prefix                                 = optional(string)
    name_append                                           = optional(string)
    name_include_app_fields                               = optional(bool)
    name_infix                                            = optional(bool)
    name_prefix                                           = optional(string)
    name_prepend                                          = optional(string)
    name_suffix                                           = optional(string)
    origin_dns_enabled                                    = optional(bool)
    origin_fqdn                                           = string
    response_security_header_content_policy_origin_map    = optional(map(list(string)))
    response_security_header_content_override             = optional(bool)
    response_security_header_content_type_override        = optional(bool)
    response_security_header_frame_option                 = optional(string)
    response_security_header_frame_override               = optional(bool)
    response_security_header_referrer_override            = optional(bool)
    response_security_header_referrer_policy              = optional(string)
    response_security_header_transport_max_age_seconds    = optional(number)
    response_security_header_transport_include_subdomains = optional(bool)
    response_security_header_transport_override           = optional(bool)
    response_security_header_transport_preload            = optional(bool)
    # The permissions below are the special sauce for the site build; log write and artifact read/write come free
    role_policy_attach_arn_map      = optional(map(string))
    role_policy_create_json_map     = optional(map(string))
    role_policy_inline_json_map     = optional(map(string))
    role_policy_managed_name_map    = optional(map(string))
    role_path                       = optional(string)
    source_branch                   = optional(string)
    source_code_star_connection_key = optional(string)
    source_repository_id            = optional(string)
  }))
}

variable "pipe_build_artifact_name_default" {
  type        = string
  default     = "site"
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

variable "pipe_webhook_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
}

variable "domain_response_security_header_content_policy_origin_map_default" {
  type = map(list(string))
  default = {
    default-src = []
  }
  description = "'self' and https://dns_from_zone_key will be prepended to all lists"
}

variable "domain_response_security_header_content_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_content_type_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_frame_option_default" {
  type    = string
  default = "DENY"
}

variable "domain_response_security_header_frame_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_referrer_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_referrer_policy_default" {
  type    = string
  default = "same-origin"
}

variable "domain_response_security_header_transport_max_age_seconds_default" {
  type        = number
  default     = 60 * 60 * 24 * 365
  description = "Must be at least one year for preloading, see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security"
}

variable "domain_response_security_header_transport_include_subdomains_default" {
  type        = bool
  default     = true
  description = "Must be true for preloading"
}

variable "domain_response_security_header_transport_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_transport_preload_default" {
  type    = bool
  default = true
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
  default     = null
  description = "Must be provided if any CDN specifies a log bucket"
}

variable "site_build_artifact_sync_path_default" {
  type    = string
  default = "."
}

variable "site_cdn_invalidation_path_default" {
  type    = string
  default = "/index.html" # Only invalidate the index file
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
