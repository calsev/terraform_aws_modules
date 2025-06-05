# There is a limit on number of resource policies, so trust Route53 once place
module "log_trust_policy" {
  source         = "../../iam/policy/resource/cw/log_group"
  log_group_name = "/aws/route53/*"
  name           = "LogGroupAllowDns"
  sid_map = {
    DnsDelivery = {
      access = "write"
      identifier_list = [
        "route53.amazonaws.com",
      ]
      identifier_type = "Service"
    }
  }
  std_map = var.std_map
}
