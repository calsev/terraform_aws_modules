variable "host_map" {
  type = map(object({
    name_override               = optional(string) # This is for imported hosts
    provider_endpoint           = string
    provider_type               = optional(string)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
    vpc_tls_certificate         = optional(string)
  }))
  default = {}
}

variable "host_provider_type_default" {
  type    = string
  default = "GitHubEnterpriseServer"
}

variable "host_vpc_tls_certificate_default" {
  type    = string
  default = null
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
  default     = null
  description = "Must be provided if a vpc_configuration is provided"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = null
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
