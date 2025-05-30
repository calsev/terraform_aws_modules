resource "aws_ec2_instance_connect_endpoint" "connect_endpoint" {
  for_each           = local.create_ice_map
  preserve_client_ip = false # Must be internal for internal_ssh_in
  security_group_ids = each.value.ec2_connect_security_group_id_list
  subnet_id          = each.value.subnet_id
  tags               = each.value.tags
}
