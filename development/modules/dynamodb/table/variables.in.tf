{{ name.var() }}

{{ iam.policy_var_ar(access=["read_write"], append="dynamodb") }}

{{ std.map() }}

variable "table_map" {
  type = map(object({
    attribute_map                  = optional(map(string))
    billing_mode                   = optional(string)
    create_policy                  = optional(bool)
    deletion_protection_enabled    = optional(bool)
    gsi_hash_key                   = optional(string)
    gsi_name                       = optional(string)
    gsi_non_key_attribute_list     = optional(list(string))
    gsi_projection_type            = optional(string)
    gsi_range_key                  = optional(string)
    gsi_read_capacity              = optional(number)
    gsi_write_capacity             = optional(number)
    hash_key                       = optional(string)
    lsi_name                       = optional(string)
    lsi_non_key_attribute_list     = optional(list(string))
    lsi_projection_type            = optional(string)
    lsi_range_key                  = optional(string)
    {{ name.var_item() }}
    point_in_time_recovery_enabled = optional(bool)
    policy_access_list             = optional(list(string))
    policy_create                  = optional(bool)
    policy_name_append             = optional(string)
    range_key                      = optional(string)
    read_capacity                  = optional(number)
    server_side_encryption_enabled = optional(bool)
    stream_enabled                 = optional(bool)
    stream_view_type               = optional(string)
    ttl_attribute_name             = optional(string)
    write_capacity                 = optional(number)
  }))
}

variable "table_attribute_map_default" {
  type        = map(string)
  default     = {}
  description = "map of name to type, must include hash keys and range keys. Types are 'S': string, 'N': number, 'B': binary."
}

variable "table_billing_mode_default" {
  type    = string
  default = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.table_billing_mode_default)
    error_message = "Invalid billing mode"
  }
}

variable "table_create_policy_default" {
  type    = bool
  default = true
}

variable "table_deletion_protection_enabled_default" {
  type    = bool
  default = true
}

variable "table_gsi_hash_key_default" {
  type    = string
  default = null
}

variable "table_gsi_name_default" {
  type    = string
  default = null
}

variable "table_gsi_non_key_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "table_gsi_projection_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["ALL", "INCLUDE", "KEYS_ONLY"], var.table_gsi_projection_type_default)
    error_message = "Invalid projection type"
  }
}

variable "table_gsi_range_key_default" {
  type    = string
  default = null
}

variable "table_gsi_read_capacity_default" {
  type    = number
  default = null
}

variable "table_gsi_write_capacity_default" {
  type    = number
  default = null
}

variable "table_hash_key_default" {
  type        = string
  default     = null
  description = "Must be LockID for a Terraform lock table"
}

variable "table_lsi_name_default" {
  type    = string
  default = null
}

variable "table_lsi_non_key_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "table_lsi_projection_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["ALL", "INCLUDE", "KEYS_ONLY"], var.table_lsi_projection_type_default)
    error_message = "Invalid projection type"
  }
}

variable "table_lsi_range_key_default" {
  type    = string
  default = null
}

variable "table_point_in_time_recovery_enabled_default" {
  type    = bool
  default = true
}

variable "table_range_key_default" {
  type    = string
  default = null
}

variable "table_read_capacity_default" {
  type    = number
  default = null
}

variable "table_server_side_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "table_stream_enabled_default" {
  type    = bool
  default = false
}

variable "table_stream_view_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.table_stream_view_type_default)
    error_message = "Invalid stream view type"
  }
}

variable "table_ttl_attribute_name_default" {
  type    = string
  default = null
}

variable "table_write_capacity_default" {
  type    = number
  default = null
}
