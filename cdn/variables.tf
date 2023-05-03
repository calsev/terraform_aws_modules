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

variable "domain_map" {
  type = map(object({
    bucket_allow_public = optional(bool)
    domain_name         = optional(string)
    origin_domain       = string
    origin_fqdn         = string
    origin_path         = optional(string)
    sid_map = optional(map(object({
      access = string
      condition_map = optional(map(object({
        test       = string
        value_list = list(string)
        variable   = string
      })))
      identifier_list = optional(list(string))
      identifier_type = optional(string)
      object_key_list = optional(list(string))
    })))
  }))
}

variable "domain_bucket_allow_public_default" {
  type    = bool
  default = false
}

variable "domain_name_default" {
  type    = string
  default = null
}

variable "domain_origin_path_default" {
  type    = string
  default = ""
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    ttl_map = map(string)
  })
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
