variable "service_list" {
  type        = list(string)
  default     = []
  description = "Statements will be synthesized for these services"
}

variable "sid_map" {
  type = map(object({
    condition_map = optional(map(object({
      test       = string
      value_list = list(string)
      variable   = string
    })))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
  }))
  default = {}
}

variable "sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "sid_identifier_type_default" {
  type    = string
  default = "AWS"
}
