variable "event_bus_arn" {
  type        = string
  default     = null
  description = "If provided, a bus will not be created"
}

variable "name" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 14
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
