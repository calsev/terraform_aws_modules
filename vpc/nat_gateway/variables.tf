variable "nat_map" {
  type = map(object({
    k_az_full = string
    tags      = map(string)
  }))
}

variable "subnet_id_map" {
  type        = map(string)
  description = "Map of k_az_full to subnet ID"
}
