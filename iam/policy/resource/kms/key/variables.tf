variable "allow_cloudtrail" {
  type    = bool
  default = true
}

variable "allow_iam_delegation" {
  type    = bool
  default = true
}

variable "key_id" {
  type = string
}

variable "policy_create" {
  type    = bool
  default = true
}

variable "std_map" {
  type = object({
    aws_account_id = string
    iam_partition  = string
  })
}
