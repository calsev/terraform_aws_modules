variable "group_map" {
  type = map(object({
    name_infix      = optional(bool)
    name_prefix     = optional(bool)
    vpc_az_key_list = optional(list(string))
    vpc_key         = optional(string)
    vpc_segment_key = optional(string)
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

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      subnet_id_map = map(string)
    }))
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
