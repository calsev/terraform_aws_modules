variable "content" {
  type = any
}

variable "name" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    config_name = string
  })
}
