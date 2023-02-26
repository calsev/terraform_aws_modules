module "managed_policies" {
  source = "../iam_policy_managed"
  policy_map = {
    batch_service    = "service-role/AWSBatchServiceRole"
    batch_spot_fleet = "service-role/AmazonEC2SpotFleetTaggingRole"
    batch_submit_job = "service-role/AWSBatchServiceEventTargetRole"
  }
  std_map = var.std_map
}
