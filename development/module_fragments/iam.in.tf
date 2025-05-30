{% import 'development/module_fragments/name.in.tf' as name %}

{% macro policy_var_item() -%}
    policy_access_list = optional(list(string))
    policy_create      = optional(bool)
    policy_name_append = optional(string)
    policy_name_prefix = optional(string)
{%- endmacro %}

{% macro _policy_var(precedence="", access=["read", "read_write", "write"], append="") -%}
variable "policy_create{{ precedence }}" {
  type    = bool
  default = true
}

variable "policy_name_append{{ precedence }}" {
  type    = string
  default = "{{ append }}"
}

variable "policy_name_prefix{{ precedence }}" {
  type    = string
  default = ""
}
{%- endmacro %}

{% macro policy_var_base(access=["read", "read_write", "write"], append="") -%}{{ _policy_var(precedence="_default", access=access, append=append) }}{%- endmacro %}

{% macro _policy_var_ar(precedence="", access=["read", "read_write", "write"], append="") -%}
variable "policy_access_list{{ precedence }}" {
  type    = list(string)
  default = {{ access | tf_list }}
}

{{ _policy_var(precedence=precedence, access=access, append=append) }}
{%- endmacro %}

{% macro policy_var_ar(access=["read", "read_write", "write"], append="") -%}{{ _policy_var_ar(precedence="_default", access=access, append=append) }}{%- endmacro %}

{% macro _policy_map_item(precedence="", source="var", append=None) -%}
    policy_create{{ precedence }}      = {{ source }}.policy_create{{ precedence }}
    policy_name_append{{ precedence }} = {{ source ~ ".policy_name_append" ~ precedence if append is none else '"' ~ append ~ '"' }}
    policy_name_prefix{{ precedence }} = {{ source }}.policy_name_prefix{{ precedence }}
{%- endmacro %}

{% macro _policy_map_item_ar(precedence="", source="var", append=None) -%}
    policy_access_list{{ precedence }} = {{ source }}.policy_access_list{{ precedence }}
    {{ _policy_map_item(precedence=precedence, source=source, append=append) }}
{%- endmacro %}

{% macro _policy_map_item_base(precedence="", source="var", map="create_policy_map", append=None) -%}
    policy_map = local.{{ map }}
    {{ _policy_map_item(precedence=precedence, source=source, append=append) }}
{%- endmacro %}

{% macro policy_map_item_ar(source="var", append=None) -%}{{ _policy_map_item_ar(precedence="_default", source=source, append=append) }}{%- endmacro %}

{% macro policy_map_item_base(source="var", map="create_policy_map", append=None) -%}{{ _policy_map_item_base(precedence="_default", source=source, map=map, append=append) }}{%- endmacro %}

{% macro policy_identity(suffix, access_list=True, map="lx_map", policy_name="this_policy", prefix=None, service="") -%}
module "{{ policy_name }}" {
  source                          = "{{ module_up }}/iam/policy/identity/{{ suffix }}"
  {{ name.map_item(prefix=prefix) }}{% if access_list %}
  policy_access_list_default      = var.policy_access_list_default{% endif %}
  policy_create_default           = var.policy_create_default
  policy_map                      = local.{{ map }}
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default{% if service %}
  policy_service_name_default     = "{{ service }}"{% endif %}
  std_map                         = var.std_map
}
{%- endmacro %}

{% macro policy_identity_ar(service="", map="lx_map", policy_name="this_policy", prefix=None) -%}{{ policy_identity(suffix="access_resource", access_list=True, policy_name=policy_name, map=map, prefix=prefix, service=service) }}{%- endmacro %}

{% macro policy_identity_base(service, map="lx_map", policy_name="this_policy", prefix=None) -%}{{ policy_identity(suffix="base", access_list=False, policy_name=policy_name, map=map, prefix=prefix, service=service) }}{%- endmacro %}

{% macro policy_identity_ar_type(suffix, map="create_policy_map", policy_name="this_policy", prefix=None) -%}{{ policy_identity(suffix=suffix, access_list=True, policy_name=policy_name, map=map, prefix=prefix, service="") }}{%- endmacro %}


{% macro role_var_item(type=None) -%}
    role_policy_attach_arn_map   = {{ type if type else "optional(map(string))" }}
    role_policy_create_json_map  = {{ type if type else "optional(map(string))" }}
    role_policy_inline_json_map  = {{ type if type else "optional(map(string))" }}
    role_policy_managed_name_map = {{ type if type else "optional(map(string))" }}
    role_path                    = {{ type if type else "optional(string)" }}
{%- endmacro %}

{% macro role_map_item(precedence="_default", source="var") -%}
    role_policy_attach_arn_map{{ precedence }}   = {{ source }}.role_policy_attach_arn_map{{ precedence }}
    role_policy_create_json_map{{ precedence }}  = {{ source }}.role_policy_create_json_map{{ precedence }}
    role_policy_inline_json_map{{ precedence }}  = {{ source }}.role_policy_inline_json_map{{ precedence }}
    role_policy_managed_name_map{{ precedence }} = {{ source }}.role_policy_managed_name_map{{ precedence }}
    role_path{{ precedence }}                    = {{ source }}.role_path{{ precedence }}
{%- endmacro %}

{% macro role_var() -%}
variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path_default" {
  type    = string
  default = null
}
{%- endmacro %}
