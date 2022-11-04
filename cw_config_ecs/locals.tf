locals {
  cw_config_name = "${var.std_map.resource_name_prefix}cloudwatch-agent-config-ecs${var.std_map.resource_name_suffix}" # This must match the read policy in IAM
}
