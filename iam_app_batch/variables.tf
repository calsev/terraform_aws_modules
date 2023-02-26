variable "name_prefix" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    assume_role_json = object({
      batch        = string
      spot_fleet   = string
      task_starter = string
    })
    iam_partition        = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
