resource "aws_route53_record" "example_com_acm_ecr" {
  name    = "ecr.example.com."
  records = ["${module.oregon_lib.std_map.aws_account_id}.dkr.ecr.${module.oregon_lib.std_map.aws_region_name}.amazonaws.com"]
  ttl     = local.ttl_map.cname
  type    = "CNAME"
  zone_id = module.dns_zone.domain_to_dns_zone_map["example.com"].dns_zone_id
}
