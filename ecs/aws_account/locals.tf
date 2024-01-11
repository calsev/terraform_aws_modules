locals {
  setting_map = {
    for k, v in var.setting_map : k => v ? "enabled" : "disabled"
  }
}
