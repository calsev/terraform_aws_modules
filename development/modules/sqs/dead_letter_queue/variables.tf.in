{{ name.var(append="dead_letter") }}

{{ iam.policy_var_ar(access=["read", "write"], append="queue") }}

variable "queue_map" {
  type = map(object({
    dead_letter_policy_create = optional(bool)
    dead_letter_queue_enabled = optional(bool)
    {{ name.var_item() }}
  }))
}

variable "queue_enabled_default" {
  type    = bool
  default = true
}

{{ std.map() }}
