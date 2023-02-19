module "this_table" {
  source  = "../dynamodb"
  std_map = var.std_map
  table_map = {
    (local.table_name) = {
      attribute_map = {
        LockID = "S"
      }
      hash_key = "LockID"
    }
  }
  table_name_infix_default                     = var.table_name_infix_default
  table_server_side_encryption_enabled_default = var.table_server_side_encryption_enabled_default
}
