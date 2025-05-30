variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
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
      log_group_name = string
    })
    log_public = optional(object({ # Must be provided if any of the projects allow public access
      policy_map = map(object({
        iam_policy_arn = string
      }))
      log_group_name = string
    }))
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
    role = object({
      build = object({
        basic = object({
          iam_role_arn = string
        })
      })
    })
  })
}

variable "ecr_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
  }))
}

variable "repo_map" {
  type = map(object({
    code_star_connection_key     = optional(string)
    build_environment_size       = optional(string) # e.g. small, medium, large
    image_build_arch_list        = optional(list(string))
    image_ecr_repo_key           = optional(string)
    image_environment_key_arch   = optional(string)
    image_environment_key_tag    = optional(string)
    image_tag_base               = optional(string)
    {{ name.var_item() }}
    {{ iam.role_var_item() }}
    source_build_spec_image      = optional(string)
    source_build_spec_manifest   = optional(string)
    vpc_access                   = optional(bool)
    vpc_az_key_list              = optional(list(string))
    vpc_key                      = optional(string)
    vpc_security_group_key_list  = optional(list(string))
    vpc_segment_key              = optional(string)
  }))
}

variable "build_code_star_connection_key_default" {
  type    = string
  default = null
}

variable "build_environment_size_default" {
  type    = string
  default = "small"
  validation {
    condition     = contains(["small", "medium", "large", "xlarge", "2xlarge"], var.build_environment_size_default)
    error_message = "Invalid environment size"
  }
}

variable "build_image_build_arch_list_default" {
  type = list(string)
  default = [
    "amd",
    "arm",
  ]
  validation {
    condition     = length(setsubtract(toset(var.build_image_build_arch_list_default), toset(["amd", "arm"]))) == 0
    error_message = "Invalid architectures"
  }
}

variable "build_image_ecr_repo_key_default" {
  type    = string
  default = null
}

variable "build_image_environment_key_arch_default" {
  type    = string
  default = "ARCH"
}

variable "build_image_environment_key_tag_default" {
  type    = string
  default = "TAG"
}

variable "build_image_tag_base_default" {
  type        = string
  default     = "latest"
  description = "The tag of the final manifest. Each arch-specific image tag will have the arch appended"
}

variable "build_source_build_spec_image_default" {
  type    = string
  default = null
}

variable "build_source_build_spec_manifest_default" {
  type    = string
  default = null
}

variable "build_vpc_access_default" {
  type    = bool
  default = true
}

{{ name.var() }}

{{ iam.role_var() }}

{{ std.map() }}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
  default     = null
  description = "Must be provided if one or more "
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
