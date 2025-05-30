variable "analyzer_map" {
  type = map(object({
    analyzer_type           = optional(string)
    {{ name.var_item() }}
    unused_access_age       = optional(number)
  }))
}

variable "analyzer_type_default" {
  type    = string
  default = "ACCOUNT"
  validation {
    condition     = contains(["ACCOUNT", "ACCOUNT_UNUSED_ACCESS", "ORGANIZATION", "ORGANIZATION_UNUSED_ACCESS"], var.analyzer_type_default)
    error_message = "Invalid analyzer type"
  }
}

variable "analyzer_unused_access_age_default" {
  type    = number
  default = 180
}

{{ name.var() }}

{{ std.map() }}
