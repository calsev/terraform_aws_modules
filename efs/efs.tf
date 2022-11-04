resource "aws_efs_file_system" "this_fs" {
  creation_token = local.resource_name
  encrypted      = var.encrypt_file_system
  tags           = local.tags
}

resource "aws_security_group" "efs_mount" {
  name = local.sg_name
  tags = merge(
    var.std_map.tags,
    {
      Name = local.sg_name
    }
  )
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "efs_mount_ingress" {
  cidr_blocks       = local.from_cidr_list
  from_port         = 2049
  ipv6_cidr_blocks  = local.from_ipv6_cidr_list
  protocol          = "tcp"
  security_group_id = aws_security_group.efs_mount.id
  to_port           = 2049
  type              = "ingress"
}

resource "aws_efs_mount_target" "this_mount_target" {
  for_each       = local.subnet_id_map
  file_system_id = aws_efs_file_system.this_fs.id
  subnet_id      = each.key
  security_groups = [
    var.security_group_id_egress,
    aws_security_group.efs_mount.id,
  ]
}
