variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = false
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
  type = list(string)
  default = [
    "/",
  ]
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

# Typically building the image will involve reading layers as well
variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read",
    "read_write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "image"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "repo_map" {
  type = map(object({
    base_image          = optional(string) # For Setting up a mirror repo
    iam_policy_json     = optional(string)
    image_tag_list      = optional(list(string))
    image_tag_max_count = optional(number)
    lifecycle_rule_list = optional(list(object({
      rulePriority = number
      selection = object({
        countNumber = number
        countType   = string
        countUnit   = string
        tagStatus   = string
      }),
      action = object({
        type = string
      })
      }
    )))
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

variable "repo_iam_policy_json_default" {
  type        = string
  default     = null
  description = "This policy will override the base policy with SIDs: LambdaGetImage"
}

variable "repo_image_tag_list_default" {
  type        = list(string)
  default     = ["latest"]
  description = "These tags will be duplicated from the base image, if both exist"
}

variable "repo_image_tag_max_count_default" {
  type    = number
  default = 1
}

variable "repo_lifecycle_rule_list_default" {
  type = list(object({
    rulePriority = number
    selection = object({
      countNumber = number
      countType   = string
      countUnit   = string
      tagStatus   = string
    }),
    action = object({
      type = string
    })
    }
  ))
  default = [
    {
      rulePriority = 1
      selection = {
        countNumber = 14
        countType   = "sinceImagePushed"
        countUnit   = "days"
        tagStatus   = "untagged"
      },
      action = {
        type = "expire"
      }
    },
  ]
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
