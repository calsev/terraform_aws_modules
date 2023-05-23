variable "account_map" {
  type = map(object({
    aws_account_id_list = list(string)
    external_id_list    = list(string)
  }))
}
