variable "group_map" {
  type = map(object({
    engine                  = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    user_map = map(object({
      access_string = string
    }))
  }))
  description = "Each group gets a disabled default user, plus one password user and one secret per user_map entry"
}

variable "group_default_user_access_string_default" {
  type        = string
  default     = "off resetchannels -@all"
  description = "The group's default user: disabled, no keys, no channels, no commands"
}

variable "group_engine_default" {
  type    = string
  default = "valkey"
  validation {
    condition     = contains(["redis", "valkey"], var.group_engine_default)
    error_message = "Invalid engine"
  }
}

variable "user_password_special_character_set_default" {
  type        = string
  default     = "!#$%&*()-_=+[]{}<>:?"
  description = "ElastiCache passwords are 16-128 printable characters without space , \" / or @"
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
