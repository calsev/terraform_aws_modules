{{ name.var() }}

{{ iam.policy_var_ar(access=["read_write"], append="service_deploy") }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    ecs_cluster_name        = string
    ecs_service_name        = string
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
