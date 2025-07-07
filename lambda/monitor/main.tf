# Function is already prepended by default
module "alarm" {
  source               = "../../cw/metric_alarm"
  alarm_map            = local.create_alarm_x_map
  name_prepend_default = ""
  std_map              = var.std_map
}
