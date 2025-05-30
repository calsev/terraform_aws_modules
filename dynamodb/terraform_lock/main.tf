module "this_table" {
  source                          = "../../dynamodb/table"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
  table_map = {
    (local.table_name) = {
      attribute_map = {
        LockID = "S"
      }
      hash_key = "LockID"
    }
  }
  table_server_side_encryption_enabled_default = var.table_server_side_encryption_enabled_default
}
