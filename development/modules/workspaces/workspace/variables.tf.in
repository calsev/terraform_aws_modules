{{ name.var() }}

{{ std.map() }}

variable "workspace_directory_data_map" {
  type = map(object({
    directory_id = string
  }))
}

variable "workspace_map" {
  type = map(object({
    bundle_id                              = optional(string)
    bundle_name                            = optional(string)
    bundle_owner                           = optional(string)
    compute_type_name                      = optional(string)
    directory_key                          = optional(string)
    kms_key_id_volume_encryption           = optional(string)
    {{ name.var_item() }}
    root_volume_encryption_enabled         = optional(bool)
    root_volume_size_gib                   = optional(number)
    running_mode                           = optional(string)
    running_mode_auto_stop_timeout_minutes = optional(number)
    user_name                              = optional(string)
    user_volume_encryption_enabled         = optional(bool)
    user_volume_size_gib                   = optional(number)
  }))
}

variable "workspace_bundle_id_default" {
  type        = string
  default     = null
  description = "To find these one can run aws workspaces describe-workspace-bundles --owner AMAZON > bundles.json"
}

variable "workspace_bundle_name_default" {
  type        = string
  default     = "Standard with Ubuntu 22.04"
  description = "Must be provided if a bundle_id is not specified for any workspace"
}

variable "workspace_bundle_owner_default" {
  type    = string
  default = "AMAZON"
}

variable "workspace_compute_type_name_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["VALUE", "STANDARD", "PERFORMANCE", "POWER", "POWERPRO", "GRAPHICS", "GRAPHICSPRO", "GRAPHICS_G4DN", "GRAPHICSPRO_G4DN"], var.workspace_compute_type_name_default)
    error_message = "Invalid compute type name"
  }
}

variable "workspace_directory_key_default" {
  type    = string
  default = null
}

variable "workspace_kms_key_id_volume_encryption_default" {
  type        = string
  default     = null
  description = "Defaults to alias/aws/workspaces"
}

variable "workspace_root_volume_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "workspace_root_volume_size_gib_default" {
  type    = number
  default = 80
  validation {
    condition     = var.workspace_root_volume_size_gib_default >= 80
    error_message = "Invalid root volume size gib"
  }
}

variable "workspace_running_mode_default" {
  type    = string
  default = "AUTO_STOP"
  validation {
    condition     = contains(["ALWAYS_ON", "AUTO_STOP"], var.workspace_running_mode_default)
    error_message = "Invalid running mode"
  }
}

variable "workspace_running_mode_auto_stop_timeout_minutes_default" {
  type    = number
  default = 60
  validation {
    condition     = var.workspace_running_mode_auto_stop_timeout_minutes_default >= 60 && var.workspace_running_mode_auto_stop_timeout_minutes_default % 60 == 0
    error_message = "Invalid running mode auto stop timeout minutes"
  }
}

variable "workspace_user_name_default" {
  type        = string
  default     = null
  description = "Defaults to key"
}

variable "workspace_user_volume_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "workspace_user_volume_size_gib_default" {
  type    = number
  default = 50
  validation {
    condition     = var.workspace_user_volume_size_gib_default >= 10
    error_message = "Invalid user volume size gib"
  }
}
