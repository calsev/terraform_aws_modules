variable "api_map" {
  type = map(object({
    authorizer_key                   = optional(string) # TODO: Authorizer
    cors_allow_credentials           = optional(bool)
    cors_allow_headers               = optional(list(string))
    cors_allow_methods               = optional(list(string))
    cors_allow_origins               = optional(list(string))
    cors_expose_headers              = optional(list(string))
    cors_max_age                     = optional(number)
    integration_iam_role_arn_default = optional(string)
    integration_map = map(object({
      http_method  = optional(string) # Ignored for sqs, step function
      iam_role_arn = optional(string)
      route_map = map(object({ # Key is "Method path" e.g. "GET /pet" or "$default"
        authorization_scopes = optional(list(string))
        authorization_type   = optional(string)
        authorizer_id        = optional(string)
        integration_id       = optional(string)
        operation_name       = optional(string)
      }))
      subtype         = optional(string)
      target_arn      = optional(string) # Used for step function
      target_uri      = optional(string) # This is ignored for step function
      timeout_seconds = optional(number)
      vpc_link_id     = optional(string)
    }))
    log_group_arn = string
    name_infix    = optional(bool)
    stage_map = map(object({ # Settings are applied uniformly to all routes for a stage
      detailed_metrics_enabled = optional(bool)
      enable_default_route     = optional(bool)
      throttling_burst_limit   = optional(number)
      throttling_rate_limit    = optional(number)
    }))
    version = optional(string)
  }))
}

variable "api_authorizer_key_default" {
  type    = string
  default = null
}

variable "api_cors_allow_credentials_default" {
  type    = bool
  default = null
}

variable "api_cors_allow_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "api_cors_allow_methods_default" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "api_cors_allow_origins_default" {
  type    = list(string)
  default = ["*"]
}

variable "api_cors_expose_headers_default" {
  type    = list(string)
  default = null
}

variable "api_cors_max_age_default" {
  type    = number
  default = null
}

variable "api_name_infix_default" {
  type    = bool
  default = true
}

variable "api_version_default" {
  type    = string
  default = "1"
}

#variable "auth_data_map" {
#  type = map(object({
#  }))
#  default     = null
#  description = "Must be provided if any API in configured for an authorizer"
#}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    ttl_map = object({
      challenge = number
    })
  })
  default = null
}

variable "domain_map" {
  type = map(object({
    validation_domain = optional(string)
  }))
  default = {}
}

variable "domain_validation_domain_default" {
  type    = string
  default = null
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
