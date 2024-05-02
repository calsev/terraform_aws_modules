locals {
  o1_map = {
    domain_to_dns_zone_map = module.dns_zone.domain_to_dns_zone_map
  }
  output_data = merge(local.o1_map, {
    dns_record            = module.dns_record.data
    domain_to_sd_zone_map = module.sd_zone_public.zone_map
    region_domain_cert_map = {
      us-west-2 = module.cert_oregon.data
    }
  })
  std_var = {
    app = "inf-dns"
    env = "prod"
  }
}
