locals {
  domain_to_dns_zone_map = {
    "example.com" : {},
    "example2.net" : {},
    "example3.com" : {},
  }
  o1_map = {
    domain_to_dns_zone_map = module.dns_zone.domain_to_dns_zone_map
    ttl_map                = local.ttl_map
  }
  output_data = merge(local.o1_map, {
    domain_to_dns_zone_map = module.dns_zone.domain_to_dns_zone_map
    domain_to_sd_zone_map  = module.sd_zone_public.zone_map
    region_domain_cert_map = {
      us-west-2 = module.cert_oregon.data
    }
  })
  region_map = {
    us-west-2 = {
      cert_map = {
        "api.example.com"      = {}
        "auth-api.example.com" = {}
      }
    }
  }
  sd_zone_list = [
    {
      dns_zone_id_parent = module.dns_zone.domain_to_dns_zone_map["example.com"].dns_zone_id
      fqdn               = "io.example.com"
    },
  ]
  std_var = {
    app = "inf-dns"
    env = "prod"
  }
  ttl_map = {
    alias     = 300
    challenge = 300
    cname     = 3600
    mx        = 600
    ns        = 172800
  }
}
