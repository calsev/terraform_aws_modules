resource "aws_sns_sms_preferences" "sms_preferences" {
  monthly_spend_limit                   = var.monthly_spend_limit
  delivery_status_iam_role_arn          = var.iam_role_arn_delivery_status
  delivery_status_success_sampling_rate = var.delivery_status_success_sampling_rate
  default_sender_id                     = var.default_sender_id_string
  default_sms_type                      = var.default_sms_type
  usage_report_s3_bucket                = var.usage_report_s3_bucket
}
