variable "compute_map" {
  type = map(object({
    capacity_type                          = optional(string)
    execute_command_log_encryption_enabled = optional(bool)
    execute_command_log_retention_days     = optional(number)
    kms_key_id_execute_command             = optional(string)
    {{ name.var_item() }}
    service_connect_default_namespace      = optional(string)
  }))
}

variable "compute_capacity_type_default" {
  type    = string
  default = "FARGATE"
  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.compute_capacity_type_default)
    error_message = "Invalid capacity type"
  }
}

variable "compute_execute_command_log_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "compute_execute_command_log_retention_days_default" {
  type    = number
  default = 7
}

variable "compute_kms_key_id_execute_command_default" {
  type    = string
  default = null
}

variable "compute_service_connect_default_namespace_default" {
  type    = string
  default = null
}

{{ name.var() }}

{{ std.map() }}
