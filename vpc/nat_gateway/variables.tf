variable "nat_map" {
  type = map(object({
    k_az_full = string
    tags      = map(string)
  }))
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "subnet_id_map" {
  type        = map(string)
  description = "Map of k_az_full to subnet ID"
}
