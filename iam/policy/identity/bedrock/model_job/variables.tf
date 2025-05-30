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

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read_write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = ""
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "policy_map" {
  type = map(object({
    access_list                             = optional(list(string))
    name_append                             = optional(string)
    name_include_app_fields                 = optional(bool)
    name_infix                              = optional(bool)
    name_prefix                             = optional(string)
    name_prepend                            = optional(string)
    name_suffix                             = optional(string)
    name_list_application_inference_profile = optional(list(string))
    name_list_job_evaluation                = optional(list(string))
    name_list_job_model_customization       = optional(list(string))
    name_list_job_model_evaluation          = optional(list(string))
    name_list_job_model_invocation          = optional(list(string))
    name_list_inference_profile             = optional(list(string))
    name_list_model_custom                  = optional(list(string))
    name_list_model_foundation              = optional(list(string))
    name_list_model_provisioned             = optional(list(string))
    policy_create                           = optional(bool)
    policy_name_append                      = optional(string)
  }))
}

variable "policy_name_list_application_inference_profile_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_job_evaluation_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_job_model_customization_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_job_model_evaluation_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_job_model_invocation_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_inference_profile_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_model_custom_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_model_foundation_default" {
  type    = list(string)
  default = []
}

variable "policy_name_list_model_provisioned_default" {
  type    = list(string)
  default = []
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
