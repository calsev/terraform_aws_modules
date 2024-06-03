locals {
  bucket_arn_list = [for bucket_name in var.bucket_name_list : (startswith(bucket_name, "arn:") ? bucket_name : "arn:${var.std_map.iam_partition}:s3:::${bucket_name}")]
  object_arn_list = [for bucket_arn in local.bucket_arn_list : "${bucket_arn}/*"]
}
