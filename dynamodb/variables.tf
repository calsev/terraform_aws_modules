variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "table_map" {
  type = map(object({
    attribute_map                  = optional(map(string))
    hash_key                       = optional(string)
    name_infix                     = optional(bool)
    point_in_time_recovery_enabled = optional(bool)
    server_side_encryption_enabled = optional(bool)
  }))
}

variable "table_attribute_map_default" {
  type    = map(string)
  default = {}
}

variable "table_hash_key_default" {
  type        = string
  default     = null
  description = "Must be LockID for a Terraform lock table"
}

variable "table_name_infix_default" {
  type    = bool
  default = true
}

variable "table_point_in_time_recovery_enabled_default" {
  type    = bool
  default = true
}

variable "table_server_side_encryption_enabled_default" {
  type    = bool
  default = true
}
