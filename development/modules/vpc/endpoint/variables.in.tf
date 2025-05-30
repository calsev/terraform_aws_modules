variable "vpc_map" {
  type = map(object({
    endpoint_map = optional(map(object({
      auto_accept_enabled  = optional(bool)
      dns_record_ip_type   = optional(string)
      endpoint_segment_key = optional(string)
      endpoint_subnet_map = optional(map(object({
        ipv4_address = optional(string) # Optional, ignored except for Gateway endpoints
        ipv6_address = optional(string) # Optional, ignored except for Gateway endpoints
      })), {})
      endpoint_type                                  = optional(string)
      iam_policy_json                                = optional(string)
      ip_address_type                                = optional(string)
      {{ name.var_item() }}
      private_dns_enabled                            = optional(bool)
      private_dns_for_inbound_resolver_endpoint_only = optional(bool)
      service_name_override                          = optional(string)
      service_name_short                             = optional(string)
      vpc_security_group_key_list                    = optional(list(string))
    })))
    non_public_segment_list = list(string)
    security_group_id_map   = map(string)
    segment_map = map(object({
      subnet_map = map(object({
        route_table_id = string
        subnet_id      = string
      }))
    }))
    vpc_assign_ipv6_cidr              = bool
    vpc_availability_zone_letter_list = list(string)
    vpc_id                            = string
  }))
}

variable "endpoint_map_default" {
  type = map(object({
    auto_accept_enabled  = optional(bool)
    dns_record_ip_type   = optional(string)
    endpoint_segment_key = optional(string)
    endpoint_subnet_map = optional(map(object({
      # Optional addresses, for Gateway endpoints only
      ipv4_address = optional(string)
      ipv6_address = optional(string)
    })), {})
    endpoint_type                                  = optional(string)
    iam_policy_json                                = optional(string)
    ip_address_type                                = optional(string)
    {{ name.var_item() }}
    private_dns_enabled                            = optional(bool)
    private_dns_for_inbound_resolver_endpoint_only = optional(bool)
    service_name_override                          = optional(string)
    service_name_short                             = optional(string)
    vpc_security_group_key_list                    = optional(list(string))
  }))
  default = {
    "ec2" = {
      auto_accept_enabled                            = null
      dns_record_ip_type                             = null
      endpoint_segment_key                           = null
      endpoint_subnet_map                            = {}
      endpoint_type                                  = null
      iam_policy_json                                = null
      ip_address_type                                = "ipv4"
      {{ name.var_item(type="null") }}
      private_dns_enabled                            = null
      private_dns_for_inbound_resolver_endpoint_only = null
      service_name_override                          = null
      service_name_short                             = null
      vpc_security_group_key_list                    = null
    }
  }
}

variable "endpoint_auto_accept_enabled_default" {
  type    = bool
  default = true
}

variable "endpoint_dns_record_ip_type_default" {
  type        = string
  default     = null
  description = "Defaults to ip_address_type"
  validation {
    condition     = var.endpoint_dns_record_ip_type_default == null ? true : var.endpoint_dns_record_ip_type_default == null ? true : contains(["dualstack", "ipv4", "ipv6", "service-defined"], var.endpoint_dns_record_ip_type_default)
    error_message = "Invalid dns record ip type"
  }
}

variable "endpoint_iam_policy_json_default" {
  type    = string
  default = null
}

variable "endpoint_ip_address_type_default" {
  type        = string
  default     = null
  description = "Defaults to dualstack if vpc_assign_ipv6_cidr else ipv4. This must be set for services that do not support IPv6."
  validation {
    condition     = var.endpoint_ip_address_type_default == null ? true : contains(["dualstack", "ipv4", "ipv6"], var.endpoint_ip_address_type_default)
    error_message = "Invalid dns record ip type"
  }
}

variable "endpoint_private_dns_enabled_default" {
  type    = bool
  default = true
}

variable "endpoint_private_dns_for_inbound_resolver_endpoint_only_default" {
  type        = bool
  default     = null
  description = "Ignored unless private_dns_enabled"
}

variable "endpoint_segment_key_default" {
  type        = string
  default     = null
  description = "Segment in which to create interfaces and Gateway endpoints. Defaults to the first entry in non_public_segment_list."
}

variable "endpoint_service_name_override_default" {
  type        = string
  default     = null
  description = "The long name of the service. Will override the default service string"
}

variable "endpoint_service_name_short_default" {
  type        = string
  default     = null
  description = "The short name of the service, e.g. 'ec2'. Will be interpolated into com.amazonaws.<region>.<service>. Defaults to key."
}

variable "endpoint_type_default" {
  type    = string
  default = "Interface"
  validation {
    condition     = contains(["Gateway", "GatewayLoadBalancer", "Interface"], var.endpoint_type_default)
    error_message = "Invalid dns record ip type"
  }
}

variable "endpoint_vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_http_in",
    "world_all_out",
  ]
}

{{ name.var() }}

{{ std.map() }}
