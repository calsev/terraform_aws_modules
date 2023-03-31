locals {
  output_data = {
    for k, v in var.nat_map : k => merge(v, {
      nat_eip_id     = aws_eip.this_eip[k].id
      nat_gateway_id = aws_nat_gateway.this_nat_gw[k].id
      nat_public_ip  = aws_eip.this_eip[k].public_ip
      nat_private_ip = aws_eip.this_eip[k].private_ip
    })
  }
}
