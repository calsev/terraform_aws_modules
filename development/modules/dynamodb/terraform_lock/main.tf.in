module "this_table" {
  source  = "../../dynamodb/table"
  {{ name.map_item() }}
  std_map = var.std_map
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
