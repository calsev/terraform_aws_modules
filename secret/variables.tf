variable "ssm_param_name" {
  type    = string
  default = null
}

variable "sm_secret_id" {
  type    = string
  default = null
}

variable "sm_secret_key" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_account_id  = string
    aws_region_name = string
    iam_partition   = string
  })
}
