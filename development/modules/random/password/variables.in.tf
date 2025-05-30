variable "random_map" {
  type = map(object({
    random_keeper_map            = optional(map(string))
    random_length                = optional(number)
    random_min_lower             = optional(number)
    random_min_numeric           = optional(number)
    random_min_special           = optional(number)
    random_min_upper             = optional(number)
    random_special_character_set = optional(string)
  }))
}

variable "random_keeper_map_default" {
  type        = map(string)
  default     = {}
  description = "A map of values that will trigger a new random value if changed"
}

variable "random_length_default" {
  type    = number
  default = 24
}

variable "random_min_lower_default" {
  type    = number
  default = 1
}

variable "random_min_numeric_default" {
  type    = number
  default = 1
}

variable "random_min_special_default" {
  type    = number
  default = 1
}

variable "random_min_upper_default" {
  type    = number
  default = 1
}

variable "random_special_character_set_default" {
  type    = string
  default = "!@#$%&*()-_=+[]{}<>:?"
}
