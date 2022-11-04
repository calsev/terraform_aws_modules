variable "acl_name" {
  type = string
}

variable "name" {
  type = string
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
