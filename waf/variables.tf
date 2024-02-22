variable "waf_map" {
  type = map(object({
    rate_limit_ip_5_minute = optional(number)
    scope                  = optional(string)
  }))
}

variable "waf_scope_default" {
  type    = string
  default = "CLOUDFRONT"
}

variable "waf_rate_limit_ip_5_minute_default" {
  type    = number
  default = 100
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
