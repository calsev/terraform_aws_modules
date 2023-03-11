variable "create_policies" {
  type    = bool
  default = true
}

variable "encrypt_file_system" {
  type    = bool
  default = true
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

variable "vpc_security_group_key_egress" {
  type    = string
  default = "world_all_out"
}

variable "vpc_segment_key" {
  type    = string
  default = "internal"
}

variable "vpc_data" {
  type = object({
    security_group_map = map(object({
      id = string
    }))
    segment_map = map(object({
      subnet_id_map = map(string)
    }))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  })
}
