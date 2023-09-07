locals {
  std_var = {
    app             = "inf-net"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
  vpc_map = {
    main = {
      peer_map = {
        # Create a VPC peering between main and test VPCs
        test = {}
      }
      segment_map = {
        public = {
          route_public = true
        }
        internal = {}
        private = {
          route_internal = false
        }
      }
      subnet_bit_length = 4 # Can fit 3 segments * 5 availability zones eventually, but we create only the default 2 AZs now
      vpc_cidr_block    = "10.0.0.0/20"
    }
    test = {
      # This is for testing only; we use the default 2 segments * 2 AZs and 2 bits per subnet
      nat_gateway_enabled = false
      vpc_cidr_block      = "10.0.16.0/20"
    }
  }
  output_data = module.vpc_stack.data
}
