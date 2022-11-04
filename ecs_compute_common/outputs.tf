output "data" {
  value = {
    arch                    = local.arch
    instance_family         = local.instance_family
    launch_template_id      = aws_launch_template.this_launch_template.id
    launch_template_version = aws_launch_template.this_launch_template.latest_version
    placement_group_id      = aws_placement_group.this_placement_group.id
    user_data               = local.user_data
  }
}
