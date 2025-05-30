variable "sid_map" {
  type = map(object({
    access = string
    condition_map = optional(map(object({
      test       = string
      value_list = list(string)
      variable   = string
    })))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
  }))
}

variable "sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "sid_identifier_type_default" {
  type    = string
  default = "*"
}

variable "sns_topic_name" {
  type = string
}

{{ std.map() }}
