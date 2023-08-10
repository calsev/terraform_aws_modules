variable "ap_map" {
  type = map(object({
    allow_public          = optional(bool)
    bucket_name_effective = string
    create_policy         = optional(bool)
    name_infix            = optional(bool)
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

variable "ap_create_policy_default" {
  type    = bool
  default = true
}

variable "ap_name_infix_default" {
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

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    tags                           = map(string)
    service_resource_access_action = map(map(map(list(string))))
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
