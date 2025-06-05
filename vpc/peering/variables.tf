variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    segment_map = map(object({
      route_internal = bool
      subnet_map = map(object({
        route_table_id = string
      }))
    }))
    peer_map = optional(map(object({ # Key can be a VPC key or VPC ID
      allow_remote_dns_resolution      = optional(bool)
      accepter_auto_accept             = optional(bool)
      manage_remote_routes             = optional(bool)
      peer_allow_remote_dns_resolution = optional(bool)
    })))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
}

variable "vpc_allow_remote_dns_resolution_default" {
  type    = bool
  default = true
}

variable "vpc_accepter_auto_accept_default" {
  type    = bool
  default = true
}

variable "vpc_manage_remote_routes_default" {
  type        = bool
  default     = true
  description = "If the VPC is not in the map (an ID), query and manage routes for all associated route tables"
}

variable "vpc_peer_allow_remote_dns_resolution_default" {
  type    = bool
  default = true
}
