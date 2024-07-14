resource "aws_macie2_account" "this_account" {
  finding_publishing_frequency = var.finding_publishing_frequency
  status                       = var.is_enabled ? "ENABLED" : "PAUSED"
}
