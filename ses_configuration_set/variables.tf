variable "config_map" {
  type = map(object({
    auto_suppress_address_reason_list              = optional(list(string))
    reputation_metrics_enabled                     = optional(bool)
    sending_enabled                                = optional(bool)
    sending_pool_name                              = optional(string)
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

variable "config_reputation_metrics_enabled_default" {
  type    = bool
  default = true
}

variable "config_sending_enabled_default" {
  type    = bool
  default = true
}

variable "config_sending_pool_name_default" {
  type    = string
  default = null
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

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
