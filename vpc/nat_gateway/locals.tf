locals {
  output_data = {
    for k, v in var.nat_map : k => merge(v, {
      eip            = module.elastic_ip.data
      eni_id         = aws_nat_gateway.this_nat_gw[k].network_interface_id
      nat_gateway_id = aws_nat_gateway.this_nat_gw[k].id
    })
  }
}
