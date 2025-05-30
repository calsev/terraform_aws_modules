variable "service_name" {
  type = string
}

variable "sid_map" {
  type = map(object({
    access = string
    condition_map = map(object({
      test       = string
      value_list = list(string)
      variable   = string
    }))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
    resource_list   = optional(list(string))
    resource_type   = string
    sid             = string
  }))
}

{{ std.map() }}
