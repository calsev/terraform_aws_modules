locals {
  create_1_sg_map = {
    for k, v in local.lx_map : k => merge(v, module.vpc.data.vpc_map[k], module.security_group_rule_set[k].data)
  }
  create_2_vpc_net_map = {
    for k, v in local.create_1_sg_map : k => merge(v, module.security_group.data[k])
  }
  create_3_vpc_peer_map = {
    for k, v in local.create_2_vpc_net_map : k => merge(v, module.vpc_net.data.vpc_map[k])
  }
  create_flow_log_map = {
    for k, v in local.lx_map : k => merge(v, {
      destination_arn = v.vpc_flow_log_destination_bucket_arn
      source_id       = module.vpc_net.data.vpc_map[k].vpc_id
    }) if v.vpc_flow_log_destination_bucket_arn != null
  }
  l0_map = {
    for k, v in var.vpc_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      vpc_flow_log_destination_bucket_key = v.vpc_flow_log_destination_bucket_key == null ? var.vpc_flow_log_destination_bucket_key_default : v.vpc_flow_log_destination_bucket_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      vpc_flow_log_destination_bucket_arn = local.l1_map[k].vpc_flow_log_destination_bucket_key == null ? null : var.s3_data_map[local.l1_map[k].vpc_flow_log_destination_bucket_key].bucket_arn
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = merge(
    # Non-standard: vpc contains multiple data maps
    module.vpc_net.data,
    {
      vpc_endpoint = module.vpc_endpoint.data
      vpc_log      = module.vpc_flow_log.data
      vpc_map      = local.create_3_vpc_peer_map
      vpc_peer     = module.vpc_peer.data
    }
  )
}
