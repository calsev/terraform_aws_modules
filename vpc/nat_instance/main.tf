# Both the public and private IPS should be stable,
# so use a static interface that outlives instances
resource "aws_network_interface" "this_interface" {
  for_each          = local.nat_map
  security_groups   = each.value.vpc_security_group_id_list
  source_dest_check = false
  subnet_id         = each.value.subnet_id
  tags              = each.value.tags
}

resource "aws_eip" "nat_eip" {
  for_each          = local.nat_map
  domain            = "vpc"
  network_interface = aws_network_interface.this_interface[each.key].id
  tags              = each.value.tags
}

module "nat_instance" {
  source       = "../../ec2/instance_template"
  compute_map  = local.nat_map
  iam_data     = var.iam_data
  monitor_data = var.monitor_data
  std_map      = var.std_map
  vpc_data_map = var.vpc_data_map
}
