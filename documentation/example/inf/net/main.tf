provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

# module "vpc_default" {
#   source  = "path/to/modules/vpc/default"
#   std_map = module.com_lib.std_map
# }

module "vpc_stack" {
  source                                      = "path/to/modules/vpc/stack"
  s3_data_map                                 = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map                                     = module.com_lib.std_map
  vpc_flow_log_destination_bucket_key_default = "example_log"
  vpc_map = {
    main = {
      nat_gateway_enabled = true
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
  vpc_nat_multi_az_default = false
}

module "load_balancer" {
  source                        = "path/to/modules/elb/load_balancer"
  dns_data                      = data.terraform_remote_state.dns.outputs.data
  elb_log_access_bucket_default = "example-log"
  elb_dns_from_zone_key_default = "example.com"
  elb_map = {
    main = {
      acm_certificate_key = "elb.example.com"
      # ip_address_type     = "dualstack-without-public-ipv4"
    }
  }
  std_map         = module.com_lib.std_map
  vpc_data_map    = module.vpc_stack.data.vpc_map
  vpc_key_default = "main"
}

module "oregon_ap" {
  source = "path/to/modules/s3/access_point"
  ap_map = {
    example_data = {
      vpc_key = "main"
    }
    example_deploy = {}
  }
  ap_name_infix_default = false
  s3_data_map           = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map               = module.com_lib.std_map
  vpc_data_map          = module.vpc_stack.data.vpc_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
