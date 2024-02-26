variable "interface_map" {
  type = map(object({
    ipv6_address_count          = optional(number)
    private_ip_count            = optional(number)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "interface_ipv6_address_count_default" {
  type        = number
  default     = 1
  description = "Ignored if VPC does not support IPv6"
}

variable "interface_private_ip_count_default" {
  type        = number
  default     = 0
  description = "This is the number of extra IPs, beyond the default"
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
  type        = list(string)
  default     = ["a"]
  description = "The first value will be used"
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_id               = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
