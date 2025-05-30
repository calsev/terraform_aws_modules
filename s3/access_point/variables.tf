variable "ap_map" {
  type = map(object({
    allow_public            = optional(bool)
    bucket_key              = optional(string) # Defaults to key
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    policy_create           = optional(bool)
    sid_map = optional(map(object({
      access = string
      condition_map = optional(map(object({
        test       = string
        value_list = list(string)
        variable   = string
      })))
      identifier_list = optional(list(string))
      identifier_type = optional(string)
      object_key_list = optional(list(string))
    })))
    vpc_key = optional(string)
  }))
}

variable "ap_allow_public_default" {
  type        = bool
  default     = false
  description = "There are 2 ways to access an S3 object: S3 URI and S3 website. 3 settings govern public access. allow_public is required for ANY public access."
}

variable "ap_policy_create_default" {
  type    = bool
  default = true
}

variable "ap_sid_condition_map_default" {
  type = map(object({
    test       = string
    value_list = list(string)
    variable   = string
  }))
  default = {}
}

variable "ap_sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "ap_sid_identifier_type_default" {
  type    = string
  default = "*"
}

variable "ap_sid_object_key_list_default" {
  type    = list(string)
  default = ["*"]
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

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
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

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
  default     = null
  description = "Must be provided if a vpc key is set"
}

variable "vpc_key_default" {
  type    = string
  default = null
}
