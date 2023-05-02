variable "vpc_az_key_list_default" {
  type = list(string)
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
  }))
}

variable "vpc_key_default" {
  type = string
}

variable "vpc_map" {
  type = map(object({
    vpc_az_key_list             = list(string)
    vpc_key                     = string
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "vpc_segment_key_default" {
  type = string
}
