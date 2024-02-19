variable "group_map" {
  type = map(object({
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_is_prefix          = optional(bool)
    name_prefix             = optional(string)
    name_suffix             = optional(string)
    vpc_az_key_list         = optional(list(string))
    vpc_key                 = optional(string)
    vpc_segment_key         = optional(string)
  }))
}

variable "group_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "It is assumed the DB transcends app organization"
}

variable "group_name_infix_default" {
  type    = bool
  default = true
}

variable "group_name_is_prefix_default" {
  type        = bool
  default     = false
  description = "If true, name will be used as a prefix"
}

variable "group_name_prefix_default" {
  type    = string
  default = ""
}

variable "group_name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
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
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
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
