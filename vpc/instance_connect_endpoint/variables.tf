variable "ec2_connect_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_ssh_in"
  ]
}

variable "subnet_data_map" {
  type = map(object({
    subnet_id = string
  }))
}

variable "vpc_map" {
  type = map(object({
    availability_zone_map_key_list      = list(string)
    ec2_connect_security_group_key_list = list(string)
    name_context                        = string
    name_simple                         = string
    non_public_segment_list             = list(string)
    security_group_id_map               = map(string)
    tags                                = map(string)
  }))
}
