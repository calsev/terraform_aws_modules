variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "cors_map" {
  type = map(object({
    acm_certificate_key = optional(string)
    alarm_map = optional(map(object({
      alarm_action_enabled                = optional(bool)
      alarm_description                   = string # Human-friendly description
      alarm_name                          = string # Human-friendly name
      alert_level                         = optional(string)
      metric_name                         = optional(string)
      metric_namespace                    = optional(string)
      statistic_comparison_operator       = optional(string)
      statistic_evaluation_period_count   = optional(number)
      statistic_evaluation_period_seconds = optional(number)
      statistic_for_metric                = optional(string)
      statistic_threshold_percentile      = optional(number)
      statistic_threshold_value           = optional(number)
    })))
    cors_allowed_headers          = optional(list(string))
    cors_allowed_hosts            = optional(list(string))
    cors_allowed_methods          = optional(list(string))
    cors_local_host_allowed       = optional(bool)
    cors_max_age                  = optional(number)
    cors_origin_default           = optional(string)
    dns_alias_enabled             = optional(bool)
    dns_from_zone_key             = optional(string)
    elb_key                       = optional(string)
    name_append                   = optional(string)
    name_include_app_fields       = optional(bool)
    name_infix                    = optional(bool)
    name_prefix                   = optional(string)
    name_prepend                  = optional(string)
    name_suffix                   = optional(string)
    reserved_concurrent_execution = optional(number)
    rule_condition_map = optional(map(object({
      http_request_method_list = optional(list(string))
      path_pattern_list        = optional(list(string))
    })))
    rule_priority               = optional(number)
    timeout_seconds             = optional(number)
    vpc_ipv6_allowed            = optional(bool)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "cors_allowed_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "cors_allowed_hosts_default" {
  type    = list(string)
  default = null
}

variable "cors_allowed_methods_default" {
  type    = list(string)
  default = ["*"]
}

variable "cors_local_host_allowed_default" {
  type    = bool
  default = true
}

variable "cors_max_age_default" {
  type    = number
  default = 600
}

variable "cors_origin_default" {
  type    = string
  default = null
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
      name_simple     = string
    })))
  })
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

variable "function_reserved_concurrent_executions_default" {
  type    = number
  default = -1
}

variable "function_timeout_seconds_default" {
  type    = number
  default = 3
}

variable "function_vpc_ipv6_allowed_default" {
  type        = bool
  default     = true
  description = "Ignored for functions not in VPC"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_lambda_vpc = string
  })
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

variable "listener_acm_certificate_key_default" {
  type        = string
  default     = null
  description = "Must be provided if a listener uses HTTPS. Ignored for other protocols."
}

variable "listener_dns_alias_enabled_default" {
  type        = bool
  default     = false
  description = "Typically when adding CORS an alias is already configured"
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_key_default" {
  type    = string
  default = null
}

variable "log_group_class_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["INFREQUENT_ACCESS", "STANDARD"], var.log_group_class_default)
    error_message = "Invalid log group class"
  }
}

variable "log_kms_key_id_default" {
  type    = string
  default = null
}

variable "log_retention_days_default" {
  type    = number
  default = 14
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
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

variable "rule_condition_map_default" {
  type = map(object({
    http_request_method_list = optional(list(string))
    path_pattern_list        = optional(list(string))
  }))
  default = {
    preflight = {}
  }
}

variable "rule_http_request_method_list_default" {
  type    = list(string)
  default = ["OPTIONS"]
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
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
