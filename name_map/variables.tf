variable "name_map" {
  type = map(object({
    name_infix  = optional(bool)
    name_prefix = optional(string)
    name_suffix = optional(string)
    tags        = optional(map(string))
  }))
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prefix_default" {
  type    = string
  default = ""
}

variable "name_regex" {
  type        = string
  default     = "/[_.]/"
  description = "This regex will be replaced with -"
}

variable "name_suffix_default" {
  type    = string
  default = ""
}

variable "resource_name_regex" {
  type        = string
  default     = "/[_.]/"
  description = "This regex will be replaced with -"
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "tags_default" {
  type    = map(string)
  default = {}
}
