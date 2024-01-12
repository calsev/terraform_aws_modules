output "data" {
  value = {
    bucket = {
      for k, v in local.lx_map : k => merge(
        module.cdn_origin_bucket.data[v.origin_fqdn],
        {
          bucket_policy_doc = module.bucket_policy[v.origin_fqdn].iam_policy_doc
        },
      )
    }
    cdn = {
      for k, v in local.lx_map : k => {
        arn = aws_cloudfront_distribution.this_distribution[k].arn
        id  = aws_cloudfront_distribution.this_distribution[k].id
      }
    }
  }
}
