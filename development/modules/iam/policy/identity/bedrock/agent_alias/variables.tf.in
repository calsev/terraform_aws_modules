{{ name.var() }}

{{ iam.policy_var_ar(access=["read_write"]) }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    {{ name.var_item() }}
    name_list_agent         = optional(list(string))
    name_map_agent_alias    = optional(map(list(string)))
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

variable "policy_name_list_agent_default" {
  type    = list(string)
  default = []
}

variable "policy_name_map_agent_alias_default" {
  type        = map(list(string))
  default     = {}
  description = "A map of agent ID to list of alias IDs. If agent is an ARN, alias list is ignored."
}

{{ std.map() }}
