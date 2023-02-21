module "log_group" {
  source  = "../log_group"
  log_map = local.log_map
  std_map = var.std_map
}

#module "log_trigger" {
#  source = "../event_trigger"
#  event_map = {
#    (each.value.log_name) = {
#      event_bus_name             = optional(string)
#      event_pattern_json         = optional(string)
#      input                      = optional(string)
#      input_path                 = optional(string)
#      input_transformer_path_map = optional(map(string))
#      input_transformer_template = optional(string)
#    }
#  }
#  std_map = var.std_map
#}
