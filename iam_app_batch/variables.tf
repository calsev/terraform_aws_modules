variable "name_prefix" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    iam_partition             = string
    resource_name_prefix      = string
    resource_name_suffix      = string
    tags                      = map(string)
    task_starter_service_list = list(string)
  })
}
