variable "policy_map" {
  type = map(string)
}

variable "std_map" {
  type = object({
    iam_partition = string
  })
}
