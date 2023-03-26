variable "cdn_global_data" {
  type = object({
    cache_policy_id_map = object({
      max_cache = string
    })
    cert = map(object({
      arn = string
    }))
    origin_request_policy_id_map = object({
      max_cache = string
    })
    web_acl_arn = string
  })
}

variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      bucket_name        = string
      iam_policy_arn_map = map(string)
    })
    code_star = object({
      connection = map(object({
        arn                = string
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

variable "code_star_connection_name" {
  type = string
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    ttl_map = map(number)
  })
}

variable "site_map" {
  type = map(object({
    bucket_domain            = string
    bucket_fqdn              = string
    build_artifact_name      = optional(string)
    build_artifact_sync_path = optional(string) # The local root path to sync to S3 bucket root
    build_list = list(object({                  # Map of name to stage data. The deploy stage is provided by this module, so typically test and build
      build_project_name = string
      # iam_role_arn         = optional(string) # The build role must be able to start the next build, and some of those are internal
      name                 = string
      output_artifact_list = optional(list(string))
    }))
    cdn_invalidation_path = optional(string)
    domain_name           = optional(string)
    # The permissions below are the special sauce for the site build; log write and artifact read/write come free
    iam_policy_arn_attach_map   = optional(map(string))
    iam_policy_json_inline_map  = optional(map(string))
    iam_policy_name_managed_map = optional(map(string))
    source_branch               = optional(string)
    source_repository_id        = string
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

variable "site_domain_name_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    env                            = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
