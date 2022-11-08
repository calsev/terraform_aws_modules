module "cdn" {
  source = "../cdn"

  cdn_global_data = var.cdn_global_data
  domain_map      = local.domain_object
  dns_data        = var.dns_data
  std_map         = var.std_map
}
