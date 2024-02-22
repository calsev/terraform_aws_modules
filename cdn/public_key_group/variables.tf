variable "group_map" {
  type = map(object({
    key_key_list = list(string)
    name_infix   = optional(bool)
  }))
}

variable "group_name_infix_default" {
  type    = bool
  default = false
}

variable "key_data_map" {
  type = map(object({
    key_id = string
  }))
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
