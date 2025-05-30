variable "group_map" {
  type = map(object({
    {{ name.var_item() }}
    name_is_prefix          = optional(bool)
    vpc_az_key_list         = optional(list(string))
    vpc_key                 = optional(string)
    vpc_segment_key         = optional(string)
  }))
}

{{ name.var(app_fields=False) }}

variable "name_is_prefix_default" {
  type        = bool
  default     = false
  description = "If true, name will be used as a prefix"
}

{{ std.map() }}

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
