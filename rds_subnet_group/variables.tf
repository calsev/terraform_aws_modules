variable "group_map" {
  type = map(object({
    name_infix          = optional(bool)
    name_prefix         = optional(bool)
    vpc_subnet_key_list = optional(list(string))
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

variable "group_vpc_subnet_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data" {
  type = object({
    segment_map = map(object({
      subnet_map = map(object({
        subnet_id = string
      }))
    }))
  })
}
