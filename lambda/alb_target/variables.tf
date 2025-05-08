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

variable "lambda_data_map" {
  type = map(object({
    lambda_arn = string
  }))
}

variable "listener_acm_certificate_key_default" {
  type        = string
  default     = null
  description = "Must be provided if a listener uses HTTPS. Ignored for other protocols."
}

variable "listener_action_order_default" {
  type    = number
  default = 10000
  validation {
    condition     = var.listener_action_order_default >= 1 && var.listener_action_order_default <= 50000
    error_message = "Invalid action order"
  }
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_key_default" {
  type    = string
  default = null
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
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

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
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
  type        = list(string)
  default     = null
  description = "Defaults to fqdn for cert if no other condition is specified. Set to [] to disable."
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

variable "std_map" {
  type = object({
    aws_account_id       = string
    aws_region_name      = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "target_map" {
  type = map(object({
    acm_certificate_key            = optional(string)
    action_order                   = optional(number)
    dns_from_zone_key              = optional(string)
    elb_key                        = optional(string)
    lambda_key                     = string
    lambda_permission_name_prepend = optional(string)
    name_append                    = optional(string)
    name_infix                     = optional(bool)
    name_override                  = optional(string)
    name_prepend                   = optional(string)
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
    vpc_key = optional(string)
  }))
}

variable "target_lambda_permission_name_prepend_default" {
  type    = string
  default = "alb_target"
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
