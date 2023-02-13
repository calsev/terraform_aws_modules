resource "local_file" "this_config" {
  content  = jsonencode(var.content)
  filename = "${path.root}/config/${var.std_map.config_name}.raw.json"
}
