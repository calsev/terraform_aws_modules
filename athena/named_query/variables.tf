variable "athena_database_map" {
  type = map(object({
    database_id : string
  }))
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "query_map" {
  type = map(object({
    database_key            = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    query                   = string
    workgroup_id            = optional(string)
  }))
}

variable "query_database_key_default" {
  type    = string
  default = null
}

variable "query_workgroup_id_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
