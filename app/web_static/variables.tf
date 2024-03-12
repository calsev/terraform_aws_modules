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
      waf_arn = string
    }))
  })
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
    })
  })
}

variable "code_star_connection_key" {
  type = string
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "site_map" {
  type = map(object({
    build_artifact_name      = optional(string)
    build_artifact_sync_path = optional(string) # The local root path to sync to S3 bucket root
    build_list = list(object({                  # Map of name to stage data. The deploy stage is provided by this module, so typically test and build
      build_project_name = string
      # iam_role_arn         = optional(string) # The build role must be able to start the next build, and some of those are internal
      name                 = string
      output_artifact_list = optional(list(string))
    }))
    cdn_invalidation_path                  = optional(string)
    ci_cd_pipeline_webhook_secret_is_param = optional(bool)
    dns_from_zone_key                      = optional(string)
    origin_dns_enabled                     = optional(bool)
    origin_fqdn                            = string
    # The permissions below are the special sauce for the site build; log write and artifact read/write come free
    policy_attach_arn_map      = optional(map(string))
    policy_create_json_map     = optional(map(string))
    policy_inline_json_map     = optional(map(string))
    policy_managed_name_map    = optional(map(string))
    source_branch              = optional(string)
    source_repository_id       = optional(string)
    webhook_enable_github_hook = optional(bool)
  }))
}

variable "site_build_artifact_name_default" {
  type        = string
  default     = "site"
  description = "The name of the artifact that contains the site directory to sync"
}

variable "site_build_artifact_sync_path_default" {
  type    = string
  default = "."
}

variable "site_cdn_invalidation_path_default" {
  type    = string
  default = "/index.html" # Only invalidate the index file
}

variable "site_ci_cd_pipeline_webhook_secret_is_param_default" {
  type    = bool
  default = false
}

variable "site_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "site_origin_dns_enabled_default" {
  type    = bool
  default = true
}

variable "site_source_repository_id_default" {
  type    = string
  default = null
}

variable "site_webhook_enable_github_hook_default" {
  type        = bool
  default     = true
  description = "Ignored if webhook is not enabled"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
