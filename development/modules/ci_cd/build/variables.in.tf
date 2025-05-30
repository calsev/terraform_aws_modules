variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
    })
    log = object({
      log_group_name = string
    })
    log_public = optional(object({ # Must be provided if any of the projects allow public access
      log_group_name = string
    }))
    role = object({
      build = object({
        basic = object({
          iam_role_arn = string
        })
      })
    })
  })
}

variable "compute_env_map" {
  type = map(object({
    image = string
  }))
  default = {
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    # Ubuntu is only built for amd64: https://github.com/aws/aws-codebuild-docker-images/blob/master/ubuntu/standard/7.0/Dockerfile
    cpu-amd-amazon = {
      image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    }
    cpu-amd-ubuntu = {
      image = "aws/codebuild/standard:7.0"
    }
    cpu-arm-amazon = {
      image = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    }
    gpu-amd-ubuntu = {
      image = "aws/codebuild/standard:7.0"
    }
  }
}

variable "repo_map" {
  type = map(object({
    build_map = map(object({
      artifact_encryption_disabled = optional(bool)
      artifact_location            = optional(string)
      artifact_namespace_type      = optional(string)
      artifact_packaging           = optional(string)
      artifact_path                = optional(string)
      artifact_type                = optional(string) # Ignored for pipeline sources
      badge_enabled                = optional(bool)   # Ignored for pipeline sources
      build_timeout_minutes        = optional(number)
      cache_modes                  = optional(list(string))
      cache_type                   = optional(string)
      concurrent_build_limit       = optional(number)
      environment_image_custom     = optional(string)
      environment_privileged_mode  = optional(bool)
      environment_type             = optional(string) # e.g. cpu-arm-ubuntu-small or gpu-amd-amazon-large
      environment_variable_map = optional(map(object({
        type  = string
        value = string
      })))
      file_system_map = optional(map(object({
        location_dns  = optional(string)
        location_path = optional(string)
        mount_options = optional(string)
        mount_point   = optional(string)
      })))
      iam_role_arn                 = optional(string)
      iam_role_arn_resource_access = optional(string)
      log_cloudwatch_enabled       = optional(bool)
      log_s3_bucket_name           = optional(string)
      log_s3_enabled               = optional(bool)
      log_s3_encryption_disabled   = optional(bool)
      {{ name.var_item() }}
      name_override                = optional(string)
      public_visibility            = optional(bool)
      source_build_spec            = optional(string)
      source_fetch_submodules      = optional(bool)
      source_git_clone_depth       = optional(number)
      source_location              = optional(string)
      source_report_build_status   = optional(bool)   # Ignored for pipeline sources
      source_type                  = optional(string) # e.g. GITHUB, GITHUB_ENTERPRISE
      source_version               = optional(string)
      vpc_az_key_list              = optional(list(string))
      vpc_key                      = optional(string)
      vpc_security_group_key_list  = optional(list(string))
      vpc_segment_key              = optional(string)
      webhook_enabled              = optional(bool)
      webhook_filter_map = optional(map(map(object({ # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook#filter
        exclude_matched_pattern = optional(bool)     # Defaults to false
        pattern                 = string
        type                    = string
      }))))
    }))
    source_location_default = optional(string)
  }))
}

variable "build_artifact_encryption_disabled_default" {
  type    = bool
  default = false
}

variable "build_artifact_location_default" {
  type    = string
  default = null
}

variable "build_artifact_namespace_type_default" {
  type    = string
  default = "BUILD_ID"
  validation {
    condition     = contains(["BUILD_ID", "NONE"], var.build_artifact_namespace_type_default)
    error_message = "Must be a valid namespace type"
  }
}

variable "build_artifact_packaging_default" {
  type        = string
  default     = "ZIP"
  description = "Ignored if artifact type is NO_ARTIFACTS"
}

variable "build_artifact_path_default" {
  type    = string
  default = null
}

variable "build_artifact_type_default" {
  type        = string
  default     = "NO_ARTIFACTS"
  description = "For Code Pipeline, the default is always NONE"
}

variable "build_badge_enabled_default" {
  type    = bool
  default = true
}

variable "build_build_timeout_minutes_default" {
  type    = number
  default = 30
}

variable "build_cache_modes_default" {
  type = list(string)
  default = [
    "LOCAL_SOURCE_CACHE",
    "LOCAL_DOCKER_LAYER_CACHE",
  ]
  description = "See https://docs.aws.amazon.com/codebuild/latest/userguide/build-caching.html.Ignored unless cache mode is LOCAL."
}

variable "build_cache_type_default" {
  type    = string
  default = "NO_CACHE"
  validation {
    condition     = contains(["LOCAL", "NO_CACHE", "S3"], var.build_cache_type_default)
    error_message = "Must be a valid cache type"
  }
}

variable "build_concurrent_limit_default" {
  type    = number
  default = null
}

variable "build_environment_image_custom_default" {
  type    = string
  default = null
}

variable "build_environment_privileged_mode_default" {
  type        = bool
  default     = false
  description = "Will be set true if file system locations are specified"
}

variable "build_environment_type_default" {
  type    = string
  default = "cpu-amd-ubuntu-small"
}

variable "build_environment_variable_map_default" {
  type = map(object({
    type  = string
    value = string
  }))
  default = {}
}

variable "build_file_system_location_dns_default" {
  type    = string
  default = null
}

variable "build_file_system_location_path_default" {
  type    = string
  default = "/"
}

variable "build_file_system_mount_options_default" {
  type    = string
  default = "nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2"
}

variable "build_file_system_mount_point_default" {
  type    = string
  default = null
}

variable "build_iam_role_arn_default" {
  type        = string
  default     = null
  description = "Defaults to the basic role in cicd account data"
}

variable "build_iam_role_arn_resource_access_default" {
  type        = string
  default     = null
  description = "Required for public access to logs"
}

variable "build_log_cloudwatch_enabled_default" {
  type    = bool
  default = true
}

variable "build_log_s3_bucket_name_default" {
  type    = string
  default = null
}

variable "build_log_s3_enabled_default" {
  type    = bool
  default = false
}

variable "build_log_s3_encryption_disabled_default" {
  type    = bool
  default = false
}

variable "build_public_visibility_default" {
  type    = bool
  default = false
}

variable "build_source_build_spec_default" {
  type    = string
  default = "build_spec/build.yml"
}

variable "build_source_fetch_submodules_default" {
  type    = bool
  default = true
}

variable "build_source_git_clone_depth_default" {
  type    = number
  default = 1
}

variable "build_source_report_build_status_default" {
  type    = bool
  default = true
}

variable "build_source_type_default" {
  type    = string
  default = "GITHUB"
  validation {
    condition     = contains(["CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "BITBUCKET", "S3", "NO_SOURCE"], var.build_source_type_default)
    error_message = "Must be a valid source type"
  }
}

variable "build_source_version_default" {
  type    = string
  default = null
}

variable "build_webhook_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored for pipe builds"
}

variable "build_webhook_filter_map_default" {
  type = map(map(object({
    exclude_matched_pattern = optional(bool)
    pattern                 = string
    type                    = string
  })))
  default = {
    # The default is to build PR commits
    pr = {
      all = {
        exclude_matched_pattern = false
        pattern                 = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
        type                    = "EVENT"
      }
    }
  }
}

{{ name.var() }}

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
