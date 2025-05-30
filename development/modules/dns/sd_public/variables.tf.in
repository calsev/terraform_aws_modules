variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "log_data_map" {
  type = map(object({
    log_group_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a log group"
}

{{ name.var(allow=["."]) }}

{{ std.map() }}

variable "zone_map" {
  type = map(object({
    dns_from_zone_key = optional(string)
    log_group_key     = optional(string)
  }))
}

variable "zone_dns_from_zone_key_default" {
  type    = string
  default = null
}


variable "zone_log_group_key_default" {
  type        = string
  default     = null
  description = "Log group must be in us-east-1 and have prefix /aws/route53. A medium-severity security finding if not specified."
}
