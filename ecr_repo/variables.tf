variable "policy_name_infix" {
  type    = bool
  default = true
}

variable "policy_name_prefix" {
  type    = string
  default = ""
}

variable "repo_map" {
  type = map(object({
    base_image          = optional(string) # For Setting up a mirror repo
    create_policy       = optional(bool)
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
    name_infix = optional(bool)
  }))
}

variable "repo_create_policy_default" {
  type    = bool
  default = true
}

variable "repo_iam_policy_json_default" {
  type    = string
  default = null
}

variable "repo_image_tag_list_default" {
  type    = list(string)
  default = ["latest"]
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

variable "repo_name_infix_default" {
  type    = bool
  default = true
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
