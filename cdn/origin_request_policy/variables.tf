variable "policy_map" {
  type = map(object({
    cache_cookie_behavior   = optional(string)
    cache_cookie_name_list  = optional(list(string))
    cache_header_behavior   = optional(string)
    cache_header_name_list  = optional(list(string))
    cache_query_behavior    = optional(string)
    cache_query_string_list = optional(list(string))
  }))
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

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
