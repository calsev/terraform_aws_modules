variable "access_list" {
  type    = list(string)
  default = ["read_write"]
}

variable "name_list_application_inference_profile" {
  type    = list(string)
  default = []
}

variable "name_list_job_evaluation" {
  type    = list(string)
  default = []
}

variable "name_list_job_model_customization" {
  type    = list(string)
  default = []
}

variable "name_list_job_model_evaluation" {
  type    = list(string)
  default = []
}

variable "name_list_job_model_invocation" {
  type    = list(string)
  default = []
}

variable "name_list_inference_profile" {
  type    = list(string)
  default = []
}

variable "name_list_model_custom" {
  type    = list(string)
  default = []
}

variable "name_list_model_foundation" {
  type    = list(string)
  default = []
}

variable "name_list_model_provisioned" {
  type    = list(string)
  default = []
}

variable "name" {
  type        = string
  default     = null
  description = "If provided, a policy will be created"
}

variable "name_infix" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix and suffix will be applied to the policy"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "If provided, will be put in front of the standard prefix for the policy"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
