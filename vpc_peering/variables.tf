variable "std_map" {
  type = object({
    aws_account_id       = string
    aws_region_name      = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data_map" {
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
    vpc_cidr_block = string
    vpc_id         = string
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
