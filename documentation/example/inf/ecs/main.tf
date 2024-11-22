provider "aws" {
  region = local.aws_region_name
}

module "com_lib" {
  source   = "path/to/modules/common"
  for_each = local.std_var_map
  std_var  = each.value
}

module "ecr_account_settings" {
  source = "path/to/modules/ecr/aws_account"
}

module "repo" {
  source = "path/to/modules/ecr/repo"
  repo_map = {
    ubuntu = {
      # These tags are for ecr-mirror
      base_image = "ubuntu"
      image_tag_list = [
        "latest",
      ]
    }
  }
  std_map = module.com_lib["com"].std_map
}

module "dns_alias" {
  source                           = "path/to/modules/dns/record"
  dns_data                         = data.terraform_remote_state.dns.outputs.data
  record_dns_from_zone_key_default = "example.com"
  record_dns_type_default          = "CNAME"
  record_map = {
    "ecr.example.com" = {
      dns_record_list = ["${module.com_lib["com"].std_map.aws_account_id}.dkr.ecr.${module.com_lib["com"].std_map.aws_region_name}.amazonaws.com"]
    }
  }
  std_map = module.com_lib["com"].std_map
}

module "latest_ami_map" {
  source = "path/to/modules/ecs/ami_map"
}

module "ecs_account_settings" {
  source  = "path/to/modules/ecs/aws_account"
  std_map = module.com_lib["com"].std_map
}

module "batch_compute" {
  source   = "path/to/modules/batch/compute"
  for_each = local.std_var_map
  compute_map = {
    # The latest AMIs can be found by running the app and inspecting the output config.
    # Change AMIs only when the compute env can be replaced.
    arm_basic = {
      instance_type = "c6g.medium" # t- not allowed on Batch
    }
    amd_basic = {
      instance_type = "m7a.medium" # t- not allowed on Batch
    }
    gpu_basic = {
      instance_type = "g4dn.xlarge" # No AMI for Radeon
    }
  }
  iam_data                = data.terraform_remote_state.iam.outputs.data
  monitor_data            = data.terraform_remote_state.monitor.outputs.data
  std_map                 = module.com_lib[each.key].std_map
  vpc_data_map            = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default         = "main"
  vpc_segment_key_default = "public"
}

module "local_config" {
  source   = "path/to/modules/local_config"
  for_each = local.std_var_map
  content  = local.output_data_map[each.key]
  std_map  = module.com_lib[each.key].std_map
}
