variable "app_map" {
  type = map(object({
    campaign_hook_lambda_function_arn = optional(string)
    campaign_hook_mode                = optional(string)
    campaign_hook_web_url             = optional(string)
    email_channel_map = optional(map(object({
      comms_ses_domain_key      = optional(string)
      enabled                   = optional(bool)
      from_username_custom      = optional(string) # Defaults to app_key-email_key
      iam_role_arn_custom       = optional(string)
      ses_configuration_set_key = optional(string)
      ses_identity_arn_custom   = optional(string)
    })))
    limit_messages_daily       = optional(number)
    limit_messages_per_second  = optional(number)
    limit_messages_total       = optional(number)
    limit_maximum_duration_min = optional(number)
    quiet_time_end_local       = optional(string)
    quiet_time_start_local     = optional(string)
    sms_channel_map = optional(map(object({
      enabled             = optional(bool)
      provider_short_code = optional(string)
      sender_id_string    = optional(string)
    })))
  }))
}

variable "app_campaign_hook_lambda_function_arn_default" {
  type    = string
  default = null
}

variable "app_campaign_hook_mode_default" {
  type        = string
  default     = "DELIVERY"
  description = "Ignored if no hook is configured"
  validation {
    condition     = contains(["DELIVERY", "FILTER"], var.app_campaign_hook_mode_default)
    error_message = "Invalid campaign hook mode"
  }
}

variable "app_email_comms_ses_domain_key_default" {
  type    = string
  default = null
}

variable "app_campaign_hook_web_url_default" {
  type    = string
  default = null
}

variable "app_email_channel_enabled_default" {
  type    = bool
  default = true
}

variable "app_email_channel_iam_role_arn_custom_default" {
  type    = string
  default = null
}

variable "app_email_channel_ses_configuration_set_key_default" {
  type    = string
  default = null
}

variable "app_email_channel_ses_identity_arn_custom_default" {
  type        = string
  default     = null
  description = "Defaults to the identity of the SES domain. Use for individually validated emails addresses."
}

variable "app_limit_messages_daily_default" {
  type    = number
  default = null
}

variable "app_limit_messages_per_second_default" {
  type    = number
  default = 50
}

variable "app_limit_messages_total_default" {
  type    = number
  default = null
}

variable "app_limit_maximum_duration_min_default" {
  type    = number
  default = 120
}

variable "app_quiet_time_end_local_default" {
  type    = string
  default = "09:00"
}

variable "app_quiet_time_start_local_default" {
  type    = string
  default = "21:00"
}

variable "app_sms_channel_enabled_default" {
  type    = bool
  default = true
}

variable "app_sms_channel_provider_short_code_default" {
  type    = string
  default = null
}

variable "app_sms_channel_sender_id_string_default" {
  type    = string
  default = null
}

variable "comms_data" {
  type = object({
    iam_policy_arn_map_mobile_analytics = map(string)
    ses_config_map = map(object({
      name_effective = string
    }))
    ses_domain_map = map(object({
      identity_arn     = string
      mail_from_domain = string
    }))
  })
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

