variable "group_map" {
  type = map(object({
    name_infix     = optional(bool)
    name_prefix    = optional(bool)
    subnet_id_list = list(string)
  }))
}

variable "group_name_infix_default" {
  type    = bool
  default = true
}

variable "group_name_prefix_default" {
  type        = bool
  default     = false
  description = "If true, name will be used as a prefix"
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
