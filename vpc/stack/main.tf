module "vpc" {
  source  = "../../vpc/vpc"
  std_map = var.std_map
  vpc_map = var.vpc_map
}

module "security_group_rule_set" {
  source   = "../../sg/rule_set"
  for_each = var.vpc_map
  std_map  = var.std_map
  vpc_map  = module.vpc.data.vpc_map
}

module "security_group" {
  source  = "../../sg/group"
  std_map = var.std_map
  vpc_map = local.sg_map
}

module "vpc_net" {
  source                   = "../../vpc/networking"
  iam_data                 = var.iam_data
  monitor_data             = var.monitor_data
  std_map                  = var.std_map
  vpc_map                  = local.vpc_net_map
  vpc_nat_multi_az_default = var.vpc_nat_multi_az_default
}

module "vpc_peer" {
  source       = "../../vpc/peering"
  std_map      = var.std_map
  vpc_data_map = local.vpc_peer_map
}
