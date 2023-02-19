variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "table_name_infix_default" {
  type    = bool
  default = false
}

variable "table_server_side_encryption_enabled_default" {
  type    = bool
  default = false
}
