module "elastic_ip" {
  source              = "../../ec2/elastic_ip"
  ip_map              = var.nat_map
  name_append_default = "nat"
  std_map             = var.std_map
}

resource "aws_nat_gateway" "this_nat_gw" {
  for_each          = var.nat_map
  allocation_id     = module.elastic_ip.data[each.key].eip_id
  connectivity_type = "public"
  subnet_id         = var.subnet_id_map[each.value.k_az_full]
  tags              = each.value.tags
}
