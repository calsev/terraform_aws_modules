variable "pool_map" {
  type = map(object({
    {{ name.var_item() }}
    scaling_mode            = optional(string)
  }))
}

{{ name.var() }}

variable "pool_scaling_mode_default" {
  type    = string
  default = "MANAGED"
  validation {
    condition     = contains(["MANAGED", "STANDARD"], var.pool_scaling_mode_default)
    error_message = "Invalid scaling mode"
  }
}

{{ std.map() }}
