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

{{ std.map() }}
