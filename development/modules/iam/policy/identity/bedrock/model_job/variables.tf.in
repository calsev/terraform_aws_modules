{{ name.var() }}

{{ iam.policy_var_ar(access=["read_write"]) }}

variable "policy_map" {
  type = map(object({
    access_list                             = optional(list(string))
    {{ name.var_item() }}
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

{{ std.map() }}
