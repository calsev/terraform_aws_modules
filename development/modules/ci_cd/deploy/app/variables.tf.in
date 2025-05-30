variable "deployment_map" {
  type = map(object({
    compute_platform        = optional(string)
    {{ name.var_item() }}
  }))
}

variable "deployment_compute_platform_default" {
  type    = string
  default = null
  validation {
    condition     = contains(["ECS", "Lambda", "Server"], var.deployment_compute_platform_default)
    error_message = "Invalid compute platform"
  }
}

{{ name.var() }}

{{ std.map() }}
