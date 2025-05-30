variable "policy_map" {
  type = map(object({
    cache_accept_encoding_brotli = optional(bool)
    cache_accept_encoding_gzip   = optional(bool)
    cache_cookie_behavior        = optional(string)
    cache_cookie_name_list       = optional(list(string))
    cache_header_behavior        = optional(string)
    cache_header_name_list       = optional(list(string))
    cache_query_behavior         = optional(string)
    cache_query_string_list      = optional(list(string))
    ttl_default_second           = optional(number)
    ttl_max_second               = optional(number)
    ttl_min_second               = optional(number)
  }))
}

variable "policy_cache_accept_encoding_brotli_default" {
  type    = bool
  default = true
}

variable "policy_cache_accept_encoding_gzip_default" {
  type    = bool
  default = true
}

variable "policy_cache_cookie_behavior_default" {
  type    = string
  default = "none"
}

variable "policy_cache_cookie_name_list_default" {
  type    = list(string)
  default = []
}

variable "policy_cache_header_behavior_default" {
  type    = string
  default = "none"
}

variable "policy_cache_header_name_list_default" {
  type    = list(string)
  default = []
}

variable "policy_cache_query_behavior_default" {
  type    = string
  default = "none"
}

variable "policy_cache_query_string_list_default" {
  type    = list(string)
  default = []
}

variable "policy_ttl_default_second_default" {
  type    = number
  default = 60 * 60 * 24
}

variable "policy_ttl_max_second_default" {
  type    = number
  default = 60 * 60 * 24 * 365
}

variable "policy_ttl_min_second_default" {
  type    = number
  default = 60 * 60 * 24
}

{{ std.map() }}
