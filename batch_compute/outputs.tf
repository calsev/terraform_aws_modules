output "data" {
  value = merge(
    module.compute_common.data,
    {
      batch_job_queue_arn = aws_batch_job_queue.this_job_queue.arn
      name                = local.name
    }
  )
}
