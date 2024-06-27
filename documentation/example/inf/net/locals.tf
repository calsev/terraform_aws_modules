locals {
  std_var = {
    app             = "inf-net"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
  output_data = merge(
    module.vpc_stack.data,
    {
      elb_map = module.load_balancer.data
      s3_ap = {
        (module.com_lib.std_map.aws_region_name) = module.oregon_ap.data
      }
    }
  )
}
