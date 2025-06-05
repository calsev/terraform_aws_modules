locals {
  filename = "${path.root}/config/${local.prefix}${var.std_map.config_name}.raw.json"
  prefix   = var.name == null ? "" : "${replace(var.name, "/[.-]/", "_")}_"
}
