resource "local_file" "this_config" {
  content  = jsonencode(var.content)
  filename = local.filename
}
