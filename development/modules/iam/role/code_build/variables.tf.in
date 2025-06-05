variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      policy = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
    code_star = object({
      connection = map(object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      }))
    })
    log = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
    log_public = optional(object({ # Must be provided if log public access is enabled
      policy_map = map(object({
        iam_policy_arn = string
      }))
    }))
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
  })
}

variable "code_star_connection_key" {
  type        = string
  default     = null
  description = "If provided, permission to use the connection will be attached"
}

variable "ecr_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
  }))
  default     = null
  description = "Must be provided if image key is specified"
}

variable "map_policy" {
  type = object({
    image_ecr_repo_key           = optional(string) # The key of the image to build. If specified read/write for the image will be granted.
    {{ iam.role_var_item() }}
  })
  default = {
    image_ecr_repo_key           = null
    {{ iam.role_var_item(type="null") }}
  }
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name" {
  type = string
}

{{ name.var() }}

variable "log_public_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for the public log"
}

variable "log_bucket_key" {
  type        = string
  default     = null
  description = "If provided, write permissions for the bucket will be added"
}

{{ iam.role_var() }}

variable "s3_data_map" {
  type = map(object({
    policy = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
  }))
  default     = null
  description = "Must be provided if a log bucket key is specified"
}

{{ std.map() }}

variable "vpc_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for VPC networking"
}
