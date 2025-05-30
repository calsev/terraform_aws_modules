{{ name.var() }}

variable "sms_map" {
  type = map(object({
    enabled                 = optional(bool)
    {{ name.var_item() }}
    pinpoint_application_id = optional(string)
    provider_short_code     = optional(string)
    sender_id_string        = optional(string)
  }))
}

variable "sms_enabled_default" {
  type    = bool
  default = true
}

variable "sms_pinpoint_application_id_default" {
  type    = string
  default = null
}

variable "sms_provider_short_code_default" {
  type        = string
  default     = null
  description = "This is just a short branding that identifies the sender. Typically at most 11 characters."
}

variable "sms_sender_id_string_default" {
  type    = string
  default = null
}

{{ std.map() }}
