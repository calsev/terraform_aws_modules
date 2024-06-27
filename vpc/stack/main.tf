module "vpc" {
  source  = "../../vpc/vpc"
  std_map = var.std_map
  vpc_map = local.lx_map
}

module "security_group_rule_set" {
  source   = "../../sg/rule_set"
  for_each = local.lx_map
  std_map  = var.std_map
  vpc_map  = module.vpc.data.vpc_map
}

module "security_group" {
  source  = "../../sg/group"
  std_map = var.std_map
  vpc_map = local.create_1_sg_map
}

module "vpc_net" {
  source                                     = "../../vpc/networking"
  iam_data                                   = var.iam_data
  monitor_data                               = var.monitor_data
  std_map                                    = var.std_map
  vpc_availability_zone_map_key_list_default = var.vpc_availability_zone_map_key_list_default
  vpc_map                                    = local.create_2_vpc_net_map
  vpc_nat_multi_az_default                   = var.vpc_nat_multi_az_default
}

module "vpc_peer" {
  source       = "../../vpc/peering"
  std_map      = var.std_map
  vpc_data_map = local.create_3_vpc_peer_map
}

module "vpc_flow_log" {
  source  = "../../ec2/flow_log"
  log_map = local.create_flow_log_map
  std_map = var.std_map
}
