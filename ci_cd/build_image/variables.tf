variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      iam_policy_arn_map = map(string)
      name_effective     = string
    })
    code_star = object({
      connection = map(object({
        iam_policy_arn_map = map(string)
      }))
    })
    log = object({
      iam_policy_arn_map = map(string)
      log_group_name     = string
    })
    log_public = optional(object({ # Must be provided if any of the projects allow public access
      iam_policy_arn_map = map(string)
      log_group_name     = string
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
    iam_policy_arn_map = object({
      read_write = string
    })
  }))
}

variable "repo_map" {
  type = map(object({
    code_star_connection_key     = optional(string)
    ecr_repo_key                 = optional(string)
    environment_key_arch         = optional(string)
    environment_key_tag          = optional(string)
    image_tag_base               = optional(string)
    name_include_app_fields      = optional(bool)
    name_infix                   = optional(bool)
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
    source_build_spec_image      = optional(string)
    source_build_spec_manifest   = optional(string)
    source_location_default      = string
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

variable "build_ecr_repo_key_default" {
  type    = string
  default = null
}

variable "build_environment_key_arch_default" {
  type    = string
  default = "ARCH"
}

variable "build_environment_key_tag_default" {
  type    = string
  default = "TAG"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
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

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "role_policy_attach_arn_map_default" {
  type        = map(string)
  default     = {}
  description = "The special sauce for the role; log write and artifact read/write come free"
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
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
