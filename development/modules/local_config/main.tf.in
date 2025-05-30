resource "local_sensitive_file" "this_config" {
  # Using sensitive file to avoid large diffs
  content         = jsonencode(var.content)
  filename        = local.filename
  file_permission = "0644"
}
