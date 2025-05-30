{{ name.var(infix=False, app_fields=False, allow=["/"]) }}

# Typically building the image will involve reading layers as well
{{ iam.policy_var_ar(access=["read", "read_write"], append="image") }}

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
    {{ name.var_item() }}
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

{{ std.map() }}
