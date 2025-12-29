variable "config_map" {
  type = map(object({
    auto_suppress_address_reason_list = optional(list(string))
    destination_map = optional(map(object({
      dimension_map = map(object({
        default_value = string
        value_source  = string
      }))
      enabled                  = optional(bool, true)
      matching_event_type_list = list(string)
    })))
    ip_pool_key                                    = optional(string)
    reputation_metrics_enabled                     = optional(bool)
    sending_enabled                                = optional(bool)
    tls_required                                   = optional(bool)
    tracking_custom_redirect_domain                = optional(string)
    vdm_dashboard_engagement_metrics_enabled       = optional(bool)
    vdm_guardian_optimized_shared_delivery_enabled = optional(bool)
  }))
}

variable "config_auto_suppress_address_reason_list_default" {
  type    = list(string)
  default = ["BOUNCE", "COMPLAINT"]
}

variable "config_destination_map_default" {
  type = map(object({
    dimension_map = map(object({
      default_value = string
      value_source  = string
    }))
    enabled                  = optional(bool, true)
    matching_event_type_list = list(string)
  }))
  default = {
    "all_events" = {
      dimension_map = {
        Header = {
          default_value = "MISSING"
          value_source  = "EMAIL_HEADER"
        }
      }
      enabled                  = true
      matching_event_type_list = ["BOUNCE", "COMPLAINT", "DELIVERY", "DELIVERY_DELAY", "REJECT", "RENDERING_FAILURE", "SEND", "SUBSCRIPTION"]
    }
  }
}

variable "config_ip_pool_key_default" {
  type    = string
  default = null
}

variable "config_reputation_metrics_enabled_default" {
  type    = bool
  default = true
}

variable "config_sending_enabled_default" {
  type    = bool
  default = true
}

variable "config_tls_required_default" {
  type    = bool
  default = true
}

variable "config_tracking_custom_redirect_domain_default" {
  type    = string
  default = null
}

variable "config_vdm_dashboard_engagement_metrics_enabled_default" {
  type    = bool
  default = true
}

variable "config_vdm_guardian_optimized_shared_delivery_enabled_default" {
  type    = bool
  default = true
}

variable "ip_pool_data_map" {
  type = map(object({
    name_effective = string
  }))
  default     = null
  description = "Must be provided if any configuration specifies an IP pool"
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
