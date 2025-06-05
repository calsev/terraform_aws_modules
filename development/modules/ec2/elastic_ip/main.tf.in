resource "aws_eip" "this_eip" {
  for_each                  = local.lx_map
  address                   = null
  associate_with_private_ip = null # A specific address
  customer_owned_ipv4_pool  = null
  domain                    = "vpc"
  instance                  = null
  network_border_group      = null
  network_interface         = null
  public_ipv4_pool          = null
  tags                      = each.value.tags
}
