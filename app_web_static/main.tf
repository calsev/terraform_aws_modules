module "cdn" {
  source = "../cdn"

  cdn_global_data     = var.cdn_global_data
  domain_map          = local.domain_object
  domain_name_default = "calsev.com"
  dns_data            = var.dns_data
  std_map             = var.std_map
}
