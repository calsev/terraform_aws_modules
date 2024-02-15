module "alert_topic" {
  source = "../../sns/topic"
  subscription_map = {
    for k in var.email_list : k => {}
  }
  topic_map = {
    for k in var.alert_level_list : k => {}
  }
  std_map = var.std_map
}
