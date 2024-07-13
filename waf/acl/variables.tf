variable "firehose_data_map" {
  type = map(object({
    firehose_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a firehose"
}

variable "log_data_map" {
  type = map(object({
    log_group_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a log group"
}

variable "log_destination_log_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_destination_firehose_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_destination_s3_bucket_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_filter_map_default" {
  type = map(object({
    default_behavior = optional(string)
    filter_map = optional(map(object({
      behavior = optional(string)
      condition_map = optional(map(object({
        action     = optional(string)
        label_name = optional(string)
      })))
      requirement = optional(string)
    })))
  }))
  default = {}
}

variable "log_filter_default_behavior_default" {
  type    = string
  default = "DROP"
  validation {
    condition     = contains(["DROP", "KEEP"], var.log_filter_default_behavior_default)
    error_message = "Invalid redacted field map"
  }
}

variable "log_filter_filter_map_default" {
  type = map(object({
    behavior = optional(string)
    condition_map = optional(map(object({
      action     = optional(string)
      label_name = optional(string)
    })))
    requirement = optional(string)
  }))
  default = {}
}

variable "log_filter_filter_behavior_default" {
  type    = string
  default = "DROP"
  validation {
    condition     = contains(["DROP", "KEEP"], var.log_filter_filter_behavior_default)
    error_message = "Invalid filter behavior"
  }
}

variable "log_filter_filter_condition_map_default" {
  type = map(object({
    action     = optional(string)
    label_name = optional(string)
  }))
  default = {}
}

variable "log_filter_filter_condition_action_default" {
  type    = string
  default = "COUNT"
  validation {
    condition     = contains(["ALLOW", "BLOCK", "COUNT"], var.log_filter_filter_condition_action_default)
    error_message = "Invalid filter action"
  }
}

variable "log_filter_filter_condition_label_name_default" {
  type    = string
  default = null
}

variable "log_filter_filter_requirement_default" {
  type    = string
  default = "MEETS_ALL"
  validation {
    condition     = contains(["MEETS_ALL", "MEETS_ANY"], var.log_filter_filter_requirement_default)
    error_message = "Invalid filter requirement"
  }
}

variable "log_redacted_field_map_default" {
  type = map(object({
    value = string
  }))
  default = {
    token = {
      value = "Authorization"
    }
  }
  description = "If value is in {method, query_string, uri_path}, that component will be redacted. Any other value will be interpreted as a header name to redact."
}

variable "s3_data_map" {
  type = map(object({
    bucket_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a bucket"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "waf_map" {
  type = map(object({
    captcha_immunity_time_seconds   = optional(number)
    challenge_immunity_time_seconds = optional(number)
    custom_response_map = optional(map(object({
      content      = optional(string)
      content_type = optional(string)
    })))
    default_action_block_custom_response_body_key = optional(string)
    default_action_block_response_code            = optional(number)
    default_action_header_map                     = optional(map(string))
    default_action_type                           = optional(string)
    log_destination_log_group_key_list            = optional(list(string))
    log_destination_firehose_key_list             = optional(list(string))
    log_destination_s3_bucket_key_list            = optional(list(string))
    log_filter_map = optional(map(object({
      default_behavior = optional(string)
      filter_map = optional(map(object({
        behavior = optional(string)
        condition_map = optional(map(object({
          action     = optional(string)
          label_name = optional(string)
        })))
        requirement = optional(string)
      })))
    })))
    log_redacted_field_map = optional(map(object({
      value = string
    })))
    metric_enabled                  = optional(bool)
    metric_sampled_requests_enabled = optional(bool)
    rule_map = optional(map(object({
      action_block_custom_response_body_key = optional(string)
      action_block_response_code            = optional(number)
      action_header_map                     = optional(map(string))
      aggregation_key_type                  = optional(string)
      aggregation_window_seconds            = optional(number)
      captcha_immunity_time_seconds         = optional(number) # Defaults to captcha_immunity_time_seconds for WAF
      limit                                 = optional(number)
      metric_enabled                        = optional(bool)
      metric_sampled_requests_enabled       = optional(bool)
      priority                              = optional(number)
      type                                  = optional(string)
    })))
    scope                                             = optional(string)
    size_inspection_limit_api_gateway_kb              = optional(number)
    size_inspection_limit_app_runner_service_kb       = optional(number)
    size_inspection_limit_cloudfront_distribution_kb  = optional(number)
    size_inspection_limit_cognito_user_pool_kb        = optional(number)
    size_inspection_limit_verified_access_instance_kb = optional(number)
    token_domain_allow_list                           = optional(list(string))
  }))
}

variable "waf_captcha_immunity_time_seconds_default" {
  type    = number
  default = 300
}

variable "waf_challenge_immunity_time_seconds_default" {
  type    = number
  default = 300
}

variable "waf_custom_response_map_default" {
  type = map(object({
    content      = optional(string)
    content_type = optional(string)
  }))
  default = {}
}

variable "waf_custom_response_content_default" {
  type    = string
  default = null
}

variable "waf_custom_response_content_type_default" {
  type    = string
  default = "APPLICATION_JSON"
  validation {
    condition     = contains(["APPLICATION_JSON", "TEXT_HTML", "TEXT_PLAIN"], var.waf_custom_response_content_type_default)
    error_message = "Invalid action type"
  }
}

variable "waf_default_action_block_custom_response_body_key_default" {
  type    = string
  default = null
}

variable "waf_default_action_block_response_code_default" {
  type    = number
  default = 404
}

variable "waf_default_action_header_map_default" {
  type        = map(string)
  default     = {}
  description = "A map of header name to value"
}

variable "waf_default_action_type_default" {
  type    = string
  default = "allow"
  validation {
    condition     = contains(["allow", "block"], var.waf_default_action_type_default)
    error_message = "Invalid action type"
  }
}

variable "waf_metric_enabled_default" {
  type    = bool
  default = true
}

variable "waf_metric_sampled_requests_enabled_default" {
  type    = bool
  default = true
}


variable "waf_rule_map_default" {
  type = map(object({
    action_block_custom_response_body_key = optional(string)
    action_block_response_code            = optional(number)
    action_header_map                     = optional(map(string))
    aggregation_key_type                  = optional(string)
    aggregation_window_seconds            = optional(number)
    captcha_immunity_time_seconds         = optional(number)
    limit                                 = optional(number)
    metric_enabled                        = optional(bool)
    metric_sampled_requests_enabled       = optional(bool)
    priority                              = optional(number)
    type                                  = optional(string)
  }))
  default = {
    ip = {
      action_block_custom_response_body_key = null
      action_block_response_code            = 429
      action_header_map                     = null
      aggregation_key_type                  = null
      aggregation_window_seconds            = null
      captcha_immunity_time_seconds         = null
      limit                                 = null
      metric_enabled                        = null
      metric_sampled_requests_enabled       = null
      priority                              = null
      type                                  = null
    }
  }
}

variable "waf_rule_action_block_custom_response_body_key_default" {
  type    = string
  default = null
}

variable "waf_rule_action_block_response_code_default" {
  type    = number
  default = 429
}

variable "waf_rule_action_header_map_default" {
  type        = map(string)
  default     = {}
  description = "Map of header name to value. Used by every action type."
}

variable "waf_rule_aggregation_key_type_default" {
  type    = string
  default = "IP"
  validation {
    condition     = contains(["CONSTANT", "CUSTOM_KEYS", "FORWARDED_IP", "IP"], var.waf_rule_aggregation_key_type_default)
    error_message = "Invalid aggregation key"
  }
}

variable "waf_rule_aggregation_window_seconds_default" {
  type    = number
  default = 300
}

variable "waf_rule_limit_default" {
  type    = number
  default = 100
  validation {
    condition     = 100 <= var.waf_rule_limit_default && var.waf_rule_limit_default <= 10000
    error_message = "Invalid rate limit"
  }
}

variable "waf_rule_metric_enabled_default" {
  type    = bool
  default = true
}

variable "waf_rule_metric_sampled_requests_enabled_default" {
  type    = bool
  default = true
}

variable "waf_rule_priority_default" {
  type    = number
  default = 1
}

variable "waf_rule_type_default" {
  type    = string
  default = "block"
  validation {
    condition     = contains(["allow", "block", "captcha", "challenge", "count"], var.waf_rule_type_default)
    error_message = "Invalid rule type"
  }
}

variable "waf_scope_default" {
  type    = string
  default = "CLOUDFRONT"
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.waf_scope_default)
    error_message = "Invalid scope"
  }
}

variable "waf_size_inspection_limit_api_gateway_kb_default" {
  type    = number
  default = 64
  validation {
    condition     = contains([16, 32, 48, 64], var.waf_size_inspection_limit_api_gateway_kb_default)
    error_message = "Invalid size"
  }
}

variable "waf_size_inspection_limit_app_runner_service_kb_default" {
  type    = number
  default = 64
  validation {
    condition     = contains([16, 32, 48, 64], var.waf_size_inspection_limit_app_runner_service_kb_default)
    error_message = "Invalid size"
  }
}

variable "waf_size_inspection_limit_cloudfront_distribution_kb_default" {
  type    = number
  default = 64
  validation {
    condition     = contains([16, 32, 48, 64], var.waf_size_inspection_limit_cloudfront_distribution_kb_default)
    error_message = "Invalid size"
  }
}

variable "waf_size_inspection_limit_cognito_user_pool_kb_default" {
  type    = number
  default = 64
  validation {
    condition     = contains([16, 32, 48, 64], var.waf_size_inspection_limit_cognito_user_pool_kb_default)
    error_message = "Invalid size"
  }
}

variable "waf_size_inspection_limit_verified_access_instance_kb_default" {
  type    = number
  default = 64
  validation {
    condition     = contains([16, 32, 48, 64], var.waf_size_inspection_limit_verified_access_instance_kb_default)
    error_message = "Invalid size"
  }
}

variable "waf_token_domain_allow_list_default" {
  type    = list(string)
  default = []
}
