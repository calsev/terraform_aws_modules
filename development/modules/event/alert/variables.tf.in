variable "alert_map" {
  type = map(object({
    alert_enabled            = optional(bool)
    alert_event_pattern_json = string
    alert_level              = optional(string)
    alert_target_path_map    = map(string)
    alert_target_template    = string
  }))
}

variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
  })
}

{{ name.var(append="failed") }}

{{ std.map() }}
