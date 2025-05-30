{% macro var_item(type=None, override=False) -%}
    name_append             = {{ type if type else "optional(string)" }}
    name_include_app_fields = {{ type if type else "optional(bool)" }}
    name_infix              = {{ type if type else "optional(bool)" }}{% if override %}
    name_override           = {{ type if type else "optional(string)" }}{% endif %}
    name_prefix             = {{ type if type else "optional(string)" }}
    name_prepend            = {{ type if type else "optional(string)" }}
    name_suffix             = {{ type if type else "optional(string)" }}
{%- endmacro %}

{% macro _var(precedence="", append="", infix=True, app_fields=True, allow=[], regex=True) -%}
variable "name_append{{ precedence }}" {
  type        = string
  default     = "{{ append }}"
  description = "Appended after key"
}

variable "name_include_app_fields{{ precedence }}" {
  type        = bool
  default     = {{ "true" if app_fields else "false" }}
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix{{ precedence }}" {
  type        = bool
  default     = {{ "true" if infix else "false" }}
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix{{ precedence }}" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend{{ precedence }}" {
  type        = string
  default     = ""
  description = "Prepended before key"
}{% if regex %}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = {{ allow | tf_list }}
  description = "By default, all punctuation is replaced by -"
}{% endif %}

variable "name_suffix{{ precedence }}" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}
{%- endmacro %}

{% macro var(append="", infix=True, app_fields=True, allow=[], regex=True) -%}{{ _var(precedence="_default", append=append, infix=infix, app_fields=app_fields, allow=allow, regex=regex) }}{%- endmacro %}

{% macro var_singular(append="", infix=True, app_fields=True, allow=[], regex=True) -%}
variable "name" {
  type        = string
}

variable "name_override_default" {
  type        = string
  default     = null
}

{{ _var(precedence="_default", append=append, infix=infix, app_fields=app_fields, allow=allow, regex=regex) }}
{%- endmacro %}

{% macro map(source_map="local.l0_map") -%}
module "name_map" {
  source                          = "{{ module_up }}/name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = {{ source_map }}
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}
{%- endmacro %}

{% macro _map_item(precedence="", source="var", override=False, append=None, prefix=None) -%}
    name_append{{ precedence }}             = {{ source ~ ".name_append" ~ precedence if append is none else '"' ~ append ~ '"' }}
    name_include_app_fields{{ precedence }} = {{ source }}.name_include_app_fields{{ precedence }}
    name_infix{{ precedence }}              = {{ source }}.name_infix{{ precedence }}{% if override %}
    name_override{{ precedence }}           = {{ source }}.name_override{{ precedence }}{% endif %}
    name_prefix{{ precedence }}             = {{ source ~ ".name_prefix" ~ precedence if prefix is none else '"' ~ prefix ~ '"' }}
    name_prepend{{ precedence }}            = {{ source }}.name_prepend{{ precedence }}
    name_suffix{{ precedence }}             = {{ source }}.name_suffix{{ precedence }}
{%- endmacro %}

{% macro map_item(source="var", override=False, append=None, prefix=None) -%}{{ _map_item(precedence="_default", source=source, override=override, append=append, prefix=prefix) }}{%- endmacro %}

{% macro map_item_singular(source="var", override=False, append=None, prefix=None) -%}{{ _map_item(precedence="", source=source, override=override, append=append, prefix=prefix) }}{%- endmacro %}
