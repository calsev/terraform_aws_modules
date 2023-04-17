locals {
  output_data = merge(
    module.vpc_net.data,
    {
      vpc_map  = local.vpc_peer_map
      vpc_peer = module.vpc_peer.data
    },
  )
  sg_map = {
    for k, v in var.vpc_map : k => merge(v, module.vpc.data.vpc_map[k], module.security_group_rule_set[k].data)
  }
  vpc_net_map = {
    for k, v in local.sg_map : k => merge(v, module.security_group.data[k])
  }
  vpc_peer_map = {
    for k, v in local.vpc_net_map : k => merge(v, module.vpc_net.data.vpc_map[k])
  }
}
